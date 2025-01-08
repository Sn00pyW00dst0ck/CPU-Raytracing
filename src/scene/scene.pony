use "../math"

class Scene 
    """
    Represents the entire 3D scene. 

    Stores all the objects in the scene.
    """

    let camera: Camera val
    let meshes: Array[Mesh val] val
    let lights: Array[Light val] val
    let _env: Env

    new val create(camera': Camera val, meshes': Array[Mesh val] val, lights': Array[Light val] val, env: Env) => 
        """"""
        camera = camera'
        meshes = meshes'
        lights = lights'
        _env = env

    fun trace(ray: Ray): (U8, U8, U8) =>
        """
        Determine the "color of a ray" based on how it intersects with the scene.
        """
        // Get closest intersection point
        let nearest_hit = this._intersect(ray, 0.001, 1_000_000)
        
        // Handle case of no hit
        if (nearest_hit._1 == false) then return (0, 0, 0) end

        // Get texture color at point of hit
        let base_color: Vector3 = match (nearest_hit._5, nearest_hit._6)
        | (let coords: Vector2, let tex: Texture val) =>
            let texture_color: (U8, U8, U8) = try tex.sample(coords._1, coords._2)? else (255, 255, 255) end
            (texture_color._1.f32() / 255.0, texture_color._2.f32() / 255.0, texture_color._3.f32() / 255.0)
        else
            (1.0, 1.0, 1.0)
        end

        // Ambient lighting
        var final_color: Vector3 = VectorMath.scale(base_color, 0.9)

        for light in lights.values() do
            // Calculate direction to light
            let light_dir: Vector3 = 
                match light.light_type
                | Point => 
                    try VectorMath.normalize(VectorMath.sub(light.position, nearest_hit._3))? else (0, 0, 0) end
                | Directional =>
                    match light.direction
                    | let dir: Vector3 => try VectorMath.normalize(dir)? else (0, 0, 0) end
                    else
                        (0, 0, 0)
                    end
                else 
                    (0, 0, 0)
                end

            // Check for shadows (cast a shadow ray)
            try 
                let shadow_ray = Ray(VectorMath.add(nearest_hit._3, VectorMath.scale(nearest_hit._4, 0.001)), light_dir)? 
                let shadow_hit = this._intersect(shadow_ray, 0.001, 1_000_000)
                if shadow_hit._1 then continue end // Skip light contribution if in shadow
            end

            // Diffuse lighting
            let dot = VectorMath.dot(nearest_hit._4, light_dir)
            if dot > 0.0 then
                let diffuse = VectorMath.magnitude(VectorMath.scale(light.color, light.intensity * dot))
                final_color = VectorMath.add(final_color, VectorMath.scale(base_color, diffuse))
            end

            // Specular lighting

        end

        // Return color as (U8, U8, U8)
        (
            (final_color._1).u8(),
            (final_color._2).u8(),
            (final_color._3).u8()
        )



    fun _intersect(ray: Ray, t_min: F32, t_max: F32): (Bool, F32, Vector3, Vector3, (Vector2 | None), (Texture val | None)) =>
        """
        Find the closest intersection of the ray with any object in the scene.
        Returns:
        - Bool: Whether the ray hit an object.
        - F32: Distance to the hit.
        - Vector3: Point of intersection.
        - Vector3: Normal at the intersection.
        - Vector2: Texture coordinate at the intersection.
        - Texture val: Texture used at intersection point (or none if texture coordinate is also none).
        """
        var nearest_hit: (Bool, F32, Vector3, Vector3, (Vector2 | None), (Texture val | None)) = (false, t_max, (0, 0, 0), (0, 0, 0), None, None)

        for mesh in meshes.values() do
            let hit_data = mesh.intersects(ray, t_min, t_max)

            match hit_data._1
            | true =>
                if (hit_data._2 < nearest_hit._2) then
                    nearest_hit = hit_data
                end
            end
        end

        nearest_hit
