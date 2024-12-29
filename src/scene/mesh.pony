use "../math"

class val Triangle
    """
    A class which represents a triangle within a mesh.
    """

    // Vertices
    let p1: Vector3
    let p2: Vector3
    let p3: Vector3
    
    // Normals
    let n1: (Vector3 | None)
    let n2: (Vector3 | None)
    let n3: (Vector3 | None)

    // Texture Coordinates
    let t1: (Vector2 | None)
    let t2: (Vector2 | None)
    let t3: (Vector2 | None)

    new val create(
        p1': Vector3, p2': Vector3, p3': Vector3,
        n1': (Vector3 | None), n2': (Vector3 | None), n3': (Vector3 | None),
        t1': (Vector2 | None), t2': (Vector2 | None), t3': (Vector2 | None)
    ) =>
        """
        Create a new triangle...
        """
        p1 = p1'
        p2 = p2'
        p3 = p3'

        n1 = n1'
        n2 = n2'
        n3 = n3'

        t1 = t1'
        t2 = t2'
        t3 = t3'

    fun box intersects(ray: Ray, t_min: F32, t_max: F32): (Bool, F32, Vector3) =>
        """
        Test for Ray-Triangle intersection...

        TODO: Update to use barycentric coordinates to calculate texture and normal at intersection point.
        """
        let edge1 = VectorMath.sub(p2, p1)
        let edge2 = VectorMath.sub(p3, p1)
        let h = VectorMath.cross(ray.direction, edge2)
        let a = VectorMath.dot(edge1, h)

        if a.abs() < 1e-8 then
            return (false, 0.0, (0.0, 0.0, 0.0))
        end

        let f = 1.0 / a
        let s = VectorMath.sub(ray.origin, p1)
        let u = f * VectorMath.dot(s, h)

        if (u < 0.0) or (u > 1.0) then
            return (false, 0.0, (0.0, 0.0, 0.0))
        end

        let q = VectorMath.cross(s, edge1)
        let v = f * VectorMath.dot(ray.direction, q)

        if (v < 0.0) or ((u + v) > 1.0) then
            return (false, 0.0, (0.0, 0.0, 0.0))
        end

        let t = f * VectorMath.dot(edge2, q)
        if (t > t_min) and (t < t_max) then
            let normal = try VectorMath.normalize(VectorMath.cross(edge1, edge2))? else (0, 0, 0) end
            (true, t, normal)
        else
            (false, 0.0, (0.0, 0.0, 0.0))
        end


class val Mesh
    """
    A class which represents a mesh.
    """

    let triangles: Array[Triangle val] val

    new val create(
        vertices': Array[Vector3] val,
        normals': Array[Vector3] val,
        tex_coords': Array[Vector2] val,
        faces': Array[((I32, I32, I32), (I32, I32, I32), (I32, I32, I32))] val
    ) =>
        """
        Create a new mesh object given the mesh data arrays.
        """
        let tri_list: Array[Triangle] iso = Array[Triangle](faces'.size())
        for face in faces'.values() do
            try 
                (let v_idxs, let n_idxs, let t_idxs) = face
                tri_list.push(
                    Triangle(
                        vertices'(v_idxs._1.usize())?, vertices'(v_idxs._2.usize())?, vertices'(v_idxs._3.usize())?,
                        normals'(n_idxs._1.usize())?, normals'(n_idxs._2.usize())?, normals'(n_idxs._3.usize())?,
                        tex_coords'(t_idxs._1.usize())?, tex_coords'(t_idxs._2.usize())?, tex_coords'(t_idxs._3.usize())?
                    )
                )
            end
        end

        triangles = consume tri_list

    fun box intersects(ray: Ray, t_min: F32, t_max: F32): () =>
        """TODO: Implement Me."""