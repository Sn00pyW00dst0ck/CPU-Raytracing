use "collections"
use "files"
use "itertools"
use "promises"

use "./math"
use "./parsers"
use "./scene"

actor Main

    new create(env: Env) => 
        """
        Program entry point.
        """
        let width: USize = 1600
        let height: USize = 1200

        env.out.print("Loading textures...")
        _load_textures(FileAuth(env.root), ["suzanne.ppm"])
            .flatten_next[Array[Mesh val] val](
                {(textures: Array[Texture val] val)(self: Main tag = this) =>
                    env.out.print("Loaded textures. Loading OBJ files...")
                    self._load_models(FileAuth(env.root), ["suzanne.obj"], textures)
                },
                {()? => 
                    env.out.print("Error loading texture files.")
                    error
                }
            )
            .next[Scene val](
                {(meshes: Array[Mesh val] val)? =>
                    env.out.print("Parsed OBJ files. Constructing scene...")
                    Scene(Camera.perspective(
                        (0, 0, 4),
                        (0, 0, 0),
                        (0, 1, 0),
                        45.0, 
                        (4.0 / 3.0)
                    )?, meshes, [
                        Light.point_light((10, 10, 10), (1.0, 1.0, 1.0), 1000, 1.0, 0.1, 0.01)
                    ], env)
                },
                {()? => 
                    env.out.print("Error parsing OBJ files.")
                    error
                }
            )
            .flatten_next[Array[(U8, U8, U8)] val](
                {(world: Scene val)(self: Main tag = this) =>
                    env.out.print("Constructed scene. Raytracing...")
                    self._raytrace_scene(width, height, world)
                },
                {()? => 
                    env.out.print("Error constructing scene from loaded models.")
                    error
                }
            )
            .next[None](
                {(pixels: Array[(U8, U8, U8)] val) =>
                    env.out.print("Finished raytracing. Writing output to file...")
                    let out_path = FilePath(FileAuth(env.root), "../output/result.ppm")
                    PPMWriter(out_path, width.u128(), height.u128(), 255, consume pixels)
                    env.out.print("Wrote output to file.")
                },
                {() => 
                    env.out.print("Error writing output to file.")
                }
            )

    fun tag _load_textures(auth: FileAuth, filenames: Array[String]): Promise[Array[Texture val] val] =>
        """
        Load the given list of textures from their filenames. 

        This is an asynchronous operation which will eventually return all the loaded 
        model's data in the form of Array[Texture val]. There is no gurantee in what order the meshes 
        are returned. 
        """
        let promise_group: Array[Promise[Texture val]] = Array[Promise[Texture val]]
        for name in filenames.values() do
            let p: Promise[Texture val] = Promise[Texture val]
            promise_group.push(p)
            PPMFileParser(FilePath(auth, "../assets/" + name), p)
        end

        Promises[Texture val].join(promise_group.values())


    fun tag _load_models(auth: FileAuth, filenames: Array[String], textures: Array[Texture val] val): Promise[Array[Mesh val] val] =>
        """
        Load the given list of models from their filenames. 

        This is an asynchronous operation which will eventually return all the loaded 
        model's data in the form of Array[Mesh]. There is no gurantee in what order the meshes 
        are returned. 
        """
        let promise_group: Array[Promise[Mesh val]] = Array[Promise[Mesh val]]
        for name in filenames.values() do
            let p: Promise[Mesh val] = Promise[Mesh val]
            promise_group.push(p)
            try ObjFileParser(FilePath(auth, "../assets/" + name), textures(0)?, p) else p.reject() end
        end

        Promises[Mesh val].join(promise_group.values())
    
    fun tag _raytrace_scene(width: USize, height: USize, scene: Scene val): Promise[Array[(U8, U8, U8)] val] =>
        """
        Raytrace the scene. 
        
        This is an asynchronous operation which will eventually return the pixel data 
        in the form of a Promise. The pixel data is returned row by row, starting with the 
        top row and ending with the bottom row.
        """
        // Create all the raycaster worker actors to raycast different parts of the scene
        let promise_group: Array[Promise[_RaycasterOutput val]] = Array[Promise[_RaycasterOutput val]]
        for group in Range[USize](0, height , 1) do // increase step size to give raycasters more work
            let p: Promise[_RaycasterOutput val] = Promise[_RaycasterOutput val]
            promise_group.push(p)
            Raycaster(group, group + 1, width, height, scene, p)
        end

        // Combine all the raycaster outputs into a pixel data promise
        Promises[_RaycasterOutput val].join(promise_group.values())
            .next[Array[(U8, U8, U8)] val]({(data: Array[_RaycasterOutput val] val) =>
                let pixels: Array[(U8, U8, U8)] iso = 
                    recover iso
                        (Iter[_RaycasterOutput val](Sort[Array[_RaycasterOutput val], _RaycasterOutput val](data.clone()).values())
                            .flat_map[(U8, U8, U8)]({(d: _RaycasterOutput val) => d.data.values() })
                            .collect[Array[(U8, U8, U8)]](Array[(U8, U8, U8)](width * height))) 
                    end
                consume pixels
            })


actor Raycaster
    """
    Worker actor that actually generates rays and calls the ray-triangle intersection algorithms...
    """
    be apply(start_row: USize, end_row: USize, width: USize, height: USize, scene: Scene val, promise: Promise[_RaycasterOutput val]) =>
        """
        A raycaster which will raycast rows from start_row to end_row (not inclusive end row) of size 'width' for the given scene. 
        Pixel color data for the row(s) is placed into the output Array that is resolved by the promise.

        TODO: could probably break into more modular sections if dividing into 'grids' instead of 'rows', but this is fine for now.
        """
        let pixels: Array[(U8, U8, U8)] iso = Array[(U8, U8, U8)](((end_row - start_row) * width).usize())

        for row in Range[USize](start_row, end_row) do
            for col in Range[USize](0, width) do
                try 
                    let ray: Ray = scene.camera.get_ray(row.f32() / width.f32(), col.f32() / height.f32())?
                    let color: (U8, U8, U8) = scene.trace(ray)
                    pixels.push(color)
                else
                    """If we reach this we failed to get a ray..."""
                end
            end
        end

        promise(_RaycasterOutput(start_row, consume pixels))

class val _RaycasterOutput is Comparable[_RaycasterOutput]
    """
    A helper class to represent raycaster output. 

    Would normally use just a tuple, but this is necessary so that we can
    sort the output of the Raycaster actors to be in the proper order.
    """
    let index: USize val
    let data: Array[(U8, U8, U8)] val

    new val create(index': USize val, data': Array[(U8, U8, U8)] val) =>
        index = index'
        data = data'

    // Implement the comparable interface so that they compare via indices.

    fun eq(other: _RaycasterOutput): Bool =>
        this.index == other.index

    fun lt(other: _RaycasterOutput): Bool =>
        this.index < other.index
