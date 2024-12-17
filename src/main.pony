use "files"

actor Main

    new create(env: Env) => 
        """"""
        env.out.print("Hello World")
        
        let path = FilePath(FileAuth(env.root), "../assets/head.obj")
        ObjFileParser(env, path)



