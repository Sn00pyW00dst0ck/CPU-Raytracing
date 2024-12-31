use "../math"

class Scene 
    """
    Represents the entire 3D scene. 

    Stores all the objects in the scene.
    """

    let camera: Camera val
    let meshes: Array[Mesh val] val
    let _env: Env

    new val create(camera': Camera val, meshes': Array[Mesh val] val, env: Env) => 
        """"""
        camera = camera'
        meshes = meshes'
        _env = env

    fun trace(ray: Ray): (U8, U8, U8) =>
        """
        Determine the "color of a ray" based on how it intersects with the scene.
        """
        // Get closest intersection point
        let nearest_hit = this._intersect(ray, 0.001, 1_000_000)
        _env.out.print(nearest_hit._1.string())
        // Compute shading at the intersection point (TODO: update to use texture, for now just white if hit)
        if (nearest_hit._1 == true) then
            (255, 255, 255)
        else
            (0, 0, 0)
        end

        // TODO: reflections




    fun _intersect(ray: Ray, t_min: F32, t_max: F32): (Bool, F32, Vector3, Vector3, (Vector2 | None)) =>
        """
        Find the closest intersection of the ray with any object in the scene.
        Returns:
        - Bool: Whether the ray hit an object.
        - F32: Distance to the hit.
        - Vector3: Point of intersection.
        - Vector3: Normal at the intersection.
        - Vector2: Texture coordinate at the intersection.
        """
        var nearest_hit: (Bool, F32, Vector3, Vector3, (Vector2 | None)) = (false, t_max, (0, 0, 0), (0, 0, 0), None)

        for mesh in meshes.values() do
            let hit_data = mesh.intersects(ray, t_min, t_max)

            match hit_data
            | (true, _, _, _, _) =>
                _env.out.print("hi")
                if (hit_data._2 < nearest_hit._2) then 
                    nearest_hit = hit_data
                end
            end
        end

        nearest_hit
