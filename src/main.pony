use "collections"
use "files"
use "itertools"
use "promises"

use "./math"
use "./scene"

actor Main

    new create(env: Env) => 
        """
        Program entry point.
        """

        let width: USize = 800
        let height: USize = 600

        env.out.print("Hello World")
        
        let path = FilePath(FileAuth(env.root), "../assets/suzanne.obj")
        
        let p: Promise[Mesh val] = Promise[Mesh val]
        p.next[Any](
            {(value: Mesh val) =>
                env.out.print("Parsed")

                try 
                    // Construct scene here
                    let world: Scene val = Scene(Camera.perspective(
                        (0, 0, 4),
                        (0, 0, 0),
                        (0, 1, 0),
                        45.0, 
                        (4.0 / 3.0)
                    )?, [value], env)

                    // Raytrace
                    let promise_group = Array[Promise[Array[(U8, U8, U8)] val]]
                    for group in Range[USize](0, height, 1) do // change step size to give raycasters more work
                        let p: Promise[Array[(U8, U8, U8)] val] = Promise[Array[(U8, U8, U8)] val]
                        promise_group.push(p)
                        Raycaster(group, group + 1, width, world, p)
                    end

                    // When all raytracing is done, collect the results into one array and write the result
                    Promises[Array[(U8, U8, U8)] val].join(promise_group.values())
                        .next[None]({(data: Array[Array[(U8, U8, U8)] val] val) =>
                            let pixels: Array[(U8, U8, U8)] iso = recover iso
                                (Iter[Array[(U8, U8, U8)] val](data.values())
                                    .flat_map[(U8, U8, U8)]({(d: Array[(U8, U8, U8)] val) => d.values() })
                                    .collect[Array[(U8, U8, U8)]](Array[(U8, U8, U8)](width * height))) end

                            let out_path = FilePath(FileAuth(env.root), "../output/result.ppm")
                            PPMWriter(out_path, width.u128(), height.u128(), 255, consume pixels)
                        })

                end

                // Write to PPM file here (demo test file)
                let out_path = FilePath(FileAuth(env.root), "../output/test.ppm")
                PPMWriter(out_path, 4, 4, 255, 
                [
                    (0, 0, 0); (0, 255, 0); (0, 255, 0); (0, 0, 0)
                    (0, 0, 0); (0, 255, 0); (0, 255, 0); (0, 0, 0)
                    (0, 0, 0); (0, 0, 0); (0, 0, 0); (0, 0, 0)
                    (0, 0, 0); (0, 0, 0); (0, 0, 0); (0, 0, 0)
                ])
            },
            {() => 
                env.out.print("Error parsing OBJ file.")
            }
        )

        ObjFileParser(path, p)

actor Raycaster
    """
    Worker actor that actually generates rays and calls the ray-triangle intersection algorithms...
    """

    be apply(start_row: USize, end_row: USize, width: USize, scene: Scene val, promise: Promise[Array[(U8, U8, U8)] val]) =>
        """
        A raycaster which will raycast rows from start_row to end_row (not inclusive end row) of size 'width' for the given scene. 
        Pixel color data for the row(s) is placed into the output Array that is resolved by the promise.

        TODO: could probably break into more modular sections if dividing into 'grids' instead of 'rows', but this is fine for now.
        """
        let pixels: Array[(U8, U8, U8)] iso = Array[(U8, U8, U8)](((end_row - start_row) * width).usize())

        for row in Range[USize](start_row, end_row) do
            for col in Range[USize](0, width) do
                try 
                    let ray: Ray = scene.camera.get_ray(row.f32(), col.f32())?
                    let color: (U8, U8, U8) = scene.trace(ray)
                    pixels.push(color)
                else
                    """If we reach this we failed to get a ray..."""
                end
            end
        end

        promise(consume pixels)

