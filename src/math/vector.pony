class Vector3[T: FloatingPoint[T] val]
    """
    A collection of 'x', 'y', and 'z' components 
    with defined mathematical operations of a 
    vector in R3. 

    Can represent a vector or a coordinate.
    """

    let x: T
    let y: T
    let z: T

    new create(x': T, y': T, z': T) =>
        """
        Create a new Vector3 from x, y, and z components.
        """
        x = consume x'
        y = consume y'
        z = consume z'

    fun box add(other: Vector3[T] box): Vector3[T] =>
        """
        Perform vector addition and return the result.
        """
        Vector3[T](x + other.x, y + other.y, z + other.z)

    fun box sub(other: Vector3[T] box): Vector3[T] =>
        """
        Perform vector subrtraction and return the result.
        """
        Vector3[T](x - other.x, y - other.y, z - other.z)

    fun box scale(scalar: T): Vector3[T] =>
        """
        Perform scalar multiplication and return the result.
        """
        Vector3[T](x * scalar, y * scalar, z * scalar)

    fun box neg(): Vector3[T] =>
        scale(T.from[I8](I8(-1)))

    fun box dot(other: Vector3[T] box): T =>
        """
        Perform (this * other) and return the result.
        """
        (x * other.x)+ (y * other.y) + (z * other.z)

    fun box cross(other: Vector3[T] box): Vector3[T] =>
        """
        Perform (this x other) and return the result.
        """
        Vector3[T](
            (y * other.z) - (z * other.y),
            (z * other.x) - (x * other.z),
            (x * other.y) - (y * other.x)
        )

    fun box magnitude(): T =>
        """
        Get the length of the vector.
        """
        ((x*x) + (y*y) + (z*z)).sqrt()

    fun box normalize(): Vector3[T]? =>
        """
        Get a unit vector pointing in the same direction as this one.

        Throws an error if the magnitude of the vector being normalized is 0.
        """
        let len = magnitude()
        if len == T.from[I8](I8(0)) then error else scale(T.from[I8](I8(1)) / len) end
