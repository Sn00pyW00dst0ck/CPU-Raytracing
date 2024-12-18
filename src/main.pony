use "files"
use "promises"

actor Main

    new create(env: Env) => 
        """"""
        env.out.print("Hello World")
        
        let path = FilePath(FileAuth(env.root), "../assets/head.obj")
        let p: Promise[Any] = Promise[Any]
        p.next[Any](
            {(value: Any) => 
                env.out.print("Parsed")
            },
            {() => 
                env.out.print("Error parsing OBJ file.")
            }
        )

        ObjFileParser(path, p)


