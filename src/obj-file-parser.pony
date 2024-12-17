use "files"

use "./math"

actor ObjFileParser
    """
    Parse an OBJ file.
    """
    // TODO: smarter way to do this...
    let vertices: Array[Vector3] = Array[Vector3](100)
    let normals: Array[Vector3] = Array[Vector3](100)
    let tex_coords: Array[Vector2] = Array[Vector2](100)
    let faces: Array[((I32, I32, I32), (I32, I32, I32), (I32, I32, I32))] = Array[((I32, I32, I32), (I32, I32, I32), (I32, I32, I32))](100)
        """The faces array holds indices into the vertices, normals, and tex_coords arrays respectively."""

    be apply(env: Env, path: FilePath) =>
        """
        Parse the OBJ file at the given FilePath.
        """
        match OpenFile(path)
        | let file: File =>
            for line in FileLines(file, 1024) do
                let parts = (consume line).split(" /")

                try
                    match parts(0)?
                    | "v" => """Parse a vertex"""
                        vertices.push((parts(1)?.f32()?, parts(2)?.f32()?, parts(3)?.f32()?))
                    | "vn" => """Parse a normal"""
                        normals.push((parts(1)?.f32()?, parts(2)?.f32()?, parts(3)?.f32()?))
                    | "vt" => """Parse a texture coordinate"""
                        tex_coords.push((parts(1)?.f32()?, parts(2)?.f32()?))
                    | "f" => """Parse a face"""
                        faces.push(((parts(1)?.i32()?, parts(2)?.i32()?, parts(3)?.i32()?), (parts(4)?.i32()?, parts(5)?.i32()?, parts(6)?.i32()?), (parts(7)?.i32()?, parts(8)?.i32()?, parts(9)?.i32()?)))
                    else
                        """Ignore anything not starting with these characters"""
                    end
                else
                    env.err.print("Error parsing line!")
                end
            end
        else
            env.err.print("Error opening file '" + path.path + "'")
        end
