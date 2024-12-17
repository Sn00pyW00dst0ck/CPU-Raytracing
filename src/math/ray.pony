class Ray
    """
    Represents a 'ray' with a starting point and a direction.
    """
    
    let origin: Vector3
    let direction: Vector3

    new create(origin': Vector3, direction': Vector3)? =>
        """
        Create a new ray with given origin and direction.
        """
        origin = origin'
        direction = VectorMath.normalize(direction')?
    
    fun box pointAt(t: F32): Vector3 =>
        """
        Get a point along the ray.
        """
        VectorMath.add(origin, VectorMath.scale(direction, t))
