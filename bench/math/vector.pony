use "pony_bench"

use "../../src/math"

actor MathBenchmarks is BenchmarkList
    fun tag benchmarks(bench: PonyBench) =>
        """
        List out all the benchmarks to run for the mathematics benchmarks.
        """
        bench(_Vector3Add((1.0, 2.0, 3.0), (1.41657, 2.0, 3.0)))
        bench(_Vector3Sub((1.0, 2.15436, 3.1643435), (1.0, 2.416572, 3.0)))
        bench(_Vector3Scale((1.0, 2.0, 3.0), 1.54621))
        bench(_Vector3Scale((1.0, -2.0, 3.0), 2.51543))
        bench(_Vector3Scale((1.1546, 2.1435164, 4.462), 200.584126))
        bench(_Vector3Dot((1.0, 2.415247, 3.0), (1.4314, 2.0, 3.8976)))
        bench(_Vector3Dot((1.0, 0.0, 0.0), (0.0, 20.0, 20.0)))
        bench(_Vector3Cross((1.0, 2.0, 3.0), (1.0, 2.0, 3.0)))
        bench(_Vector3Cross((1.5415, 0.0, 0.0), (0.0, 20.1456, 20.89826)))
        bench(_Vector3Magnitude((1.0, 2.0, 3.0)))
        bench(_Vector3Magnitude((1.312657, 2.462151, 3.547641)))
        bench(_Vector3Normalize((1.0, 51.461145, 0.41534)))

class iso _Vector3Add is MicroBenchmark
    """
    Performance checking for testing Vector3 addition.
    """
    let _a: Vector3
    let _b: Vector3

    new iso create(a: Vector3, b: Vector3) =>
        _a = a
        _b = b

    fun name(): String =>
        "VectorMath.add( (" + _a._1.string() + ", " + _a._2.string() + ", " + _a._3.string() + "), (" + _b._1.string() + ", " + _b._2.string() + ", " + _b._3.string() + ") )"

    fun apply() =>
        VectorMath.add(_a, _b)

class iso _Vector3Sub is MicroBenchmark
    """
    Performance checking for testing Vector3 subtraction.
    """
    let _a: Vector3
    let _b: Vector3

    new iso create(a: Vector3, b: Vector3) =>
        _a = a
        _b = b

    fun name(): String =>
        "VectorMath.sub( (" + _a._1.string() + ", " + _a._2.string() + ", " + _a._3.string() + "), (" + _b._1.string() + ", " + _b._2.string() + ", " + _b._3.string() + ") )"

    fun apply() =>
        VectorMath.sub(_a, _b)

class iso _Vector3Scale is MicroBenchmark
    """
    Performance checking for testing Vector3 subtraction.
    """
    let _a: Vector3
    let _s: F32

    new iso create(a: Vector3, s: F32) =>
        _a = a
        _s = s

    fun name(): String =>
        "VectorMath.scale(" + _a._1.string() + ", " + _a._2.string() + ", " + _a._3.string() + ", " + _s.string() + ")"

    fun apply() =>
        VectorMath.scale(_a, _s)

class iso _Vector3Dot is MicroBenchmark
    """
    Performance checking for testing Vector3 subtraction.
    """
    let _a: Vector3
    let _b: Vector3

    new iso create(a: Vector3, b: Vector3) =>
        _a = a
        _b = b

    fun name(): String =>
        "VectorMath.dot( (" + _a._1.string() + ", " + _a._2.string() + ", " + _a._3.string() + "), (" + _b._1.string() + ", " + _b._2.string() + ", " + _b._3.string() + ") )"

    fun apply() =>
        VectorMath.dot(_a, _b)

class iso _Vector3Cross is MicroBenchmark
    """
    Performance checking for testing Vector3 subtraction.
    """
    let _a: Vector3
    let _b: Vector3

    new iso create(a: Vector3, b: Vector3) =>
        _a = a
        _b = b

    fun name(): String =>
        "VectorMath.cross( (" + _a._1.string() + ", " + _a._2.string() + ", " + _a._3.string() + "), (" + _b._1.string() + ", " + _b._2.string() + ", " + _b._3.string() + ") )"

    fun apply() =>
        VectorMath.cross(_a, _b)

class iso _Vector3Magnitude is MicroBenchmark
    """
    Performance checking for testing Vector3 subtraction.
    """
    let _a: Vector3

    new iso create(a: Vector3) =>
        _a = a

    fun name(): String =>
        "VectorMath.magnitude( (" + _a._1.string() + ", " + _a._2.string() + ", " + _a._3.string() + ") )"

    fun apply() =>
        VectorMath.magnitude(_a)

class iso _Vector3Normalize is MicroBenchmark
    """
    Performance checking for testing Vector3 subtraction.
    """
    let _a: Vector3

    new iso create(a: Vector3) =>
        _a = a

    fun name(): String =>
        "VectorMath.normalize( (" + _a._1.string() + ", " + _a._2.string() + ", " + _a._3.string() + ") )"

    fun apply(): None? =>
        VectorMath.normalize(_a)? 
