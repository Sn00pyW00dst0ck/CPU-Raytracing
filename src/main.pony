use "files"
use "promises"

use "./scene"

actor Main

    new create(env: Env) => 
        """"""
        env.out.print("Hello World")
        
        let path = FilePath(FileAuth(env.root), "../assets/suzanne.obj")
        
        let p: Promise[Mesh val] = Promise[Mesh val]
        p.next[Any](
            {(value: Mesh val) =>
                env.out.print("Parsed")
                // Construct scene here
                // Raytrace here
                // Write to PNG file here
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


