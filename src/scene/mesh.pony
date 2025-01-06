use "../math"


class val Mesh
    """
    A class which represents a mesh.
    """

    let triangles: Array[Triangle val] val

    new val create(
        vertices': Array[Vector3] val,
        normals': Array[Vector3] val,
        tex_coords': Array[Vector2] val,
        faces': Array[((I32, I32, I32), (I32, I32, I32), (I32, I32, I32))] val,
        texture': (Texture val | None)
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
                        tex_coords'(t_idxs._1.usize())?, tex_coords'(t_idxs._2.usize())?, tex_coords'(t_idxs._3.usize())?,
                        texture'
                    )
                )
            end
        end

        triangles = consume tri_list

    fun box intersects(ray: Ray, t_min: F32, t_max: F32) : (Bool, F32, Vector3, Vector3, (Vector2 | None), (Texture val | None)) => 
        """
        Get the nearest intersection of the ray with the mesh.
        """
        var nearest_hit: (Bool, F32, Vector3, Vector3, (Vector2 | None), (Texture val | None)) = (false, t_max, (0, 0, 0), (0, 0, 0), None, None)

        for triangle in triangles.values() do
            let hit_data = triangle.intersects(ray, t_min, t_max)

            match hit_data._1
            | true =>
                if (hit_data._2 < nearest_hit._2) then 
                    nearest_hit = hit_data
                end
            end
        end

        nearest_hit
