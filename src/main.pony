use "collections"
use "files"
use "promises"

use "./math"
use "./scene"

actor Main

    new create(env: Env) => 
        """
        Program entry point.
        """
        env.out.print("Hello World")
        
        let path = FilePath(FileAuth(env.root), "../assets/suzanne.obj")
        
        let p: Promise[Mesh val] = Promise[Mesh val]
        p.next[Any](
            {(value: Mesh val) =>
                env.out.print("Parsed")
                // Construct scene here

                // Raytrace here

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
        A raycaster which will raycast rows from start_row to end_row of size 'width' for the given scene. 
        Pixel color data for the row(s) is placed into the output Array that is resolved by the promise.

        TODO: could probably break into more modular sections if dividing into 'grids' instead of 'rows', but this is fine for now.
        """
        let pixels: Array[(U8, U8, U8)] iso = Array[(U8, U8, U8)](((end_row - start_row) * width).usize())

        for row in Range[USize](start_row, end_row + 1) do
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

