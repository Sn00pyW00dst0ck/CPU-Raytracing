use "../math"

class Scene 
    """
    Represents the entire 3D scene. 

    Stores all the objects in the scene.
    """

    let meshes: Array[Mesh]

    new create(meshes': Array[Mesh]) => 
        """"""
        meshes = meshes'

    fun intersect(ray: Ray, t_min: F32, t_max: F32): (Bool, F32, Vector3, Vector3) =>
        """
        Find the closest intersection of the ray with any object in the scene.
        Returns:
        - Bool: Whether the ray hit an object.
        - F64: Distance to the hit.
        - Vector3: Point of intersection.
        - Vector3: Normal at the intersection.
        """
        var hit_anything = false
        var closest_t: F32 = t_max
        var hit_point: Vector3 = (0.0, 0.0, 0.0)
        var hit_normal: Vector3 = (0.0, 0.0, 0.0)

        for mesh in meshes.values() do
            """
            TODO: Determine intersection with mesh, store closest hit.
            """
        end

        (hit_anything, closest_t, hit_point, hit_normal)



