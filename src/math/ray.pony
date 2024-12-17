class Ray[T: FloatingPoint[T] val]
    """
    Represents a 'ray' with a starting point and a direction.
    """
    
    let origin: Vector3[T]
    let direction: Vector3[T]

    new create(origin': Vector3[T], direction': Vector3[T])? =>
        """
        Create a new ray with given origin and direction.
        """
        origin = origin'
        direction = direction'.normalize()?
    
    fun box pointAt(t: T): Vector3[T] =>
        """
        Get a point along the ray.
        """
        origin + direction.scale(t)
