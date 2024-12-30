use "../math"

class Scene 
    """
    Represents the entire 3D scene. 

    Stores all the objects in the scene.
    """

    let camera: Camera
    let meshes: Array[Mesh]

    new create(camera': Camera, meshes': Array[Mesh]) => 
        """"""
        camera = camera'
        meshes = meshes'

    fun trace(ray: Ray): (U8, U8, U8) =>
        """
        Determine the "color of a ray" based on how it intersects with the scene.
        """
        (0, 0, 0)
        // TODO: Find the closest intersection
        // TODO: Compute shading at the intersection point
        // TODO: Handle Reflections


    fun intersect(ray: Ray, t_min: F32, t_max: F32): (Bool, F32, Vector3, Vector3) =>
        """
        Find the closest intersection of the ray with any object in the scene.
        Returns:
        - Bool: Whether the ray hit an object.
        - F32: Distance to the hit.
        - Vector3: Point of intersection.
        - Vector3: Normal at the intersection.
        - Vector2: Texture coordinate at the intersection.
        """
        var hit_anything = false
        var closest_t: F32 = t_max
        var hit_point: Vector3 = (0.0, 0.0, 0.0)
        var hit_normal: Vector3 = (0.0, 0.0, 0.0)

        for mesh in meshes.values() do
            """
            TODO: Determine intersection with mesh(es), store closest hit.
            """
        end

        (hit_anything, closest_t, hit_point, hit_normal)
