use "../math"

class Mesh
    let vertices: Array[Vector3] val
    let normals: Array[Vector3] val
    let tex_coords: Array[Vector2] val
    let faces: Array[((I32, I32, I32), (I32, I32, I32), (I32, I32, I32))] val

    new val create(
        vertices': Array[Vector3] val,
        normals': Array[Vector3] val,
        tex_coords': Array[Vector2] val,
        faces': Array[((I32, I32, I32), (I32, I32, I32), (I32, I32, I32))] val
    ) =>
        """
        Create a new mesh object given the mesh data arrays.
        """
        vertices = vertices'
        normals = normals'
        tex_coords = tex_coords'
        faces = faces'