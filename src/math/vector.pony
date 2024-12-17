// Use tuples to represent vectors, because this is more performant than classes.
type Vector2 is (F32, F32)
type Vector3 is (F32, F32, F32)
type Vector4 is (F32, F32, F32, F32)

// Define operations on vectors.
primitive VectorMath
    fun add(a: Vector3, b: Vector3): Vector3 =>
        """
        Perform the vector addition (a + b).
        """
        (a._1 + b._1, a._2 + b._2, a._3 + b._3)

    fun sub(a: Vector3, b: Vector3): Vector3 =>
        """
        Perform the vector subtraction (a - b).
        """
        (a._1 - b._1, a._2 - b._2, a._3 - b._3)

    fun scale(a: Vector3, scalar: F32): Vector3 =>
        """
        Scale the vector 'a' by a set amount.
        """
        (a._1 * scalar, a._2 * scalar, a._3 * scalar)

    fun dot(a: Vector3, b: Vector3): F32 =>
        """
        Get the result of the dot product (a * b).
        """
        (a._1 * b._1) + (a._2 * b._2) + (a._3 * b._3)

    fun cross(a: Vector3, b: Vector3): Vector3 =>
        """
        Get the result of the cross product (a x b).
        """
        (
            (a._2 * b._3) - (a._3 * b._2),
            (a._3 * b._1) - (a._1 * b._3),
            (a._1 * b._2) - (a._2 * b._1)
        )

    fun magnitude(a: Vector3): F32 =>
        """
        Get the magnitude (length) of the vector 'a'.
        """
        (a._1.powi(2) + a._2.powi(2) + a._3.powi(2)).sqrt()

    fun normalize(a: Vector3): Vector3? =>
        """
        Get the normalized version of the vector 'a'.

        Throws an error if the magnitude of 'a' is 0.
        """
        let len: F32 = magnitude(a)
        if len == 0 then error else scale(a, 1/len) end

    // TODO: Define operations for Vector2 and Vector4, and for conversions...
