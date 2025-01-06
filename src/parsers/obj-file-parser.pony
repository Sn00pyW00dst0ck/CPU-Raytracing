use "files"
use "promises"

use "../math"
use "../scene"

actor ObjFileParser
    """
    Parse an OBJ file.
    """

    be apply(path: FilePath, texture: (Texture val | None), promise: Promise[Mesh val]) =>
        """
        Parse the OBJ file at the given FilePath.

        When done, will fulfill the provided promise so that the caller can perform some action after completion.
        """
        var vertices: Array[Vector3] iso = Array[Vector3](100)
        var normals: Array[Vector3] iso = Array[Vector3](100)
        var tex_coords: Array[Vector2] iso = Array[Vector2](100)
        var faces: Array[((I32, I32, I32), (I32, I32, I32), (I32, I32, I32))] iso = Array[((I32, I32, I32), (I32, I32, I32), (I32, I32, I32))](100)
            """The faces array holds indices into the vertices, normals, and tex_coords arrays respectively."""

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
                    """If we reach this location, there was an error parsing the line."""
                    promise.reject()
                end
            end
        else
            """If we reach this location, there was an error opening the file."""
            promise.reject()
        end

        // Notify that we have parsed
        promise(Mesh(consume vertices, consume  normals, consume tex_coords, consume faces, texture))

// TODO: figure out benchmarking... If this is relatively slow then we should optimize it to hell and back