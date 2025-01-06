use "pony_test"

use "../../src/math"
use "../../src/scene"

class iso TriangleTests is TestList
    """
    Tests for Triangle class.
    """
    new create(env: Env) => PonyTest(env, this)
    new make() => None

    fun tag tests(test: PonyTest) =>
        _TriangleIntersectionTests.make().tests(test)



class iso _TriangleIntersectionTests is TestList
    """
    Listing of the Triangle intersection tests.
    """
    new create(env: Env) => PonyTest(env, this)
    new make() => None

    fun tag tests(test: PonyTest) =>
        test(_TriangleBasicIntersectionTest)
        test(_TriangleNoIntersectionTest)
        test(_TriangleParallelRayIntersectionTest)
        test(_TriangleIntersectionAtEdgeTest)
        test(_TriangleIntersectionAtVertexTest)
        test(_TriangleIntersectionStartInPlaneTest)
        test(_TriangleBackfacingIntersectionTest)

class iso _TriangleBasicIntersectionTest is UnitTest
    fun name(): String => "Basic Triangle Intersection"

    fun apply(h: TestHelper) =>
        try 
            let triangle = Triangle((0, 0, 0), (0, 1, 0), (1, 0, 0), None, None, None, None, None, None, None)
            let ray = Ray((0.5, 0.5, -1), (0, 0, 1))?
            let hit_data = triangle.intersects(ray, 0.01, 1000.0)
            // Ensure hit
            h.assert_true(hit_data._1)
            // Ensure proper distance
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._2, 1))
            // Ensure the location of intersection is correct
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._3._1, 0.5))
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._3._2, 0.5))
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._3._3, 0.0))
            // Ensure expected normal (0,0,-1)
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._4._1, 0.0))
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._4._2, 0.0))
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._4._3, -1))
            // Ensure no texture coordinates
            match hit_data._5
            | None => """"""
            else
                h.fail()
            end
        else 
            h.fail()
        end

class iso _TriangleNoIntersectionTest is UnitTest
    fun name(): String => "Triangle No Intersection"

    fun apply(h: TestHelper) =>
        try 
            let triangle = Triangle((0, 0, 0), (0, 1, 0), (1, 0, 0), None, None, None, None, None, None, None)
            let ray = Ray((2, 2, -1), (0, 0, 1))?
            let hit_data = triangle.intersects(ray, 0.01, 1000.0)
            // Ensure no hit
            h.assert_false(hit_data._1)
        else 
            h.fail()
        end

class iso _TriangleParallelRayIntersectionTest is UnitTest
    fun name(): String => "Triangle Parallel Ray Intersection"

    fun apply(h: TestHelper) =>
        try 
            let triangle = Triangle((0, 0, 0), (0, 1, 0), (1, 0, 0), None, None, None, None, None, None, None)
            let ray = Ray((0.5, 0.5, -1), (1, 1, 0))?
            let hit_data = triangle.intersects(ray, 0.01, 1000.0)
            // Ensure no hit
            h.assert_false(hit_data._1)
        else 
            h.fail()
        end

class iso _TriangleIntersectionAtEdgeTest is UnitTest
    fun name(): String => "Triangle At Edge Intersection"

    fun apply(h: TestHelper) =>
        try 
            let triangle = Triangle((0, 0, 0), (0, 1, 0), (1, 0, 0), None, None, None, None, None, None, None)
            let ray = Ray((0.5, 0.0, -1), (0, 0, 1))?
            let hit_data = triangle.intersects(ray, 0.01, 1000.0)
            // Ensure hit
            h.assert_true(hit_data._1)
            // Ensure proper distance
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._2, 1))
            // Ensure the location of intersection is correct
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._3._1, 0.5))
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._3._2, 0.0))
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._3._3, 0.0))
            // Ensure expected normal (0,0,-1)
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._4._1, 0.0))
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._4._2, 0.0))
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._4._3, -1))
            // Ensure no texture coordinates
            match hit_data._5
            | None => """"""
            else
                h.fail()
            end
        else 
            h.fail()
        end

class iso _TriangleIntersectionAtVertexTest is UnitTest
    fun name(): String => "Triangle At Verterx Intersection"

    fun apply(h: TestHelper) =>
        try 
            let triangle = Triangle((0, 0, 0), (0, 1, 0), (1, 0, 0), None, None, None, None, None, None, None)
            let ray = Ray((0.0, 0.0, -1), (0, 0, 1))?
            let hit_data = triangle.intersects(ray, 0.01, 1000.0)
            // Ensure hit
            h.assert_true(hit_data._1)
            // Ensure proper distance
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._2, 1))
            // Ensure the location of intersection is correct
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._3._1, 0.0))
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._3._2, 0.0))
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._3._3, 0.0))
            // Ensure expected normal (0,0,-1)
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._4._1, 0.0))
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._4._2, 0.0))
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._4._3, -1))
            // Ensure no texture coordinates
            match hit_data._5
            | None => """"""
            else
                h.fail()
            end
        else 
            h.fail()
        end

class iso _TriangleIntersectionStartInPlaneTest is UnitTest
        fun name(): String => "Triangle Ray Starting In Plane Intersection"

    fun apply(h: TestHelper) =>
        try 
            let triangle = Triangle((0, 0, 0), (0, 1, 0), (1, 0, 0), None, None, None, None, None, None, None)
            let ray = Ray((0.25, 0.25, 0), (0, 0, 1))?
            let hit_data = triangle.intersects(ray, 0, 1000.0)
            // Ensure hit
            h.assert_true(hit_data._1)
            // Ensure proper distance
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._2, 0))
            // Ensure the location of intersection is correct
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._3._1, 0.25))
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._3._2, 0.25))
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._3._3, 0.0))
            // Ensure expected normal (0,0,-1)
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._4._1, 0.0))
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._4._2, 0.0))
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._4._3, -1))
            // Ensure no texture coordinates
            match hit_data._5
            | None => """"""
            else
                h.fail()
            end
        else 
            h.fail()
        end

class iso _TriangleBackfacingIntersectionTest is UnitTest
    fun name(): String => "Triangle Backfacing Intersection"

    fun apply(h: TestHelper) =>
        try 
            let triangle = Triangle((0, 0, 0), (1, 0, 0), (0, 1, 0), None, None, None, None, None, None, None)
            let ray = Ray((0.0, 0.0, -1), (0, 0, 1))?
            let hit_data = triangle.intersects(ray, 0.01, 1000.0)
            // Ensure hit
            h.assert_true(hit_data._1)
            // Ensure proper distance
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._2, 1))
            // Ensure the location of intersection is correct
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._3._1, 0.0))
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._3._2, 0.0))
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._3._3, 0.0))
            // Ensure expected normal (0,0,1)
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._4._1, 0.0))
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._4._2, 0.0))
            h.assert_true(_TriangleTestHelpers.compareFloats[F32](hit_data._4._3, 1))
            // Ensure no texture coordinates
            match hit_data._5
            | None => """"""
            else
                h.fail()
            end
        else 
            h.fail()
        end

primitive _TriangleTestHelpers
    fun compareFloats[A: FloatingPoint[A] val](x: A, y: A, tolerance: A = A.from[F64](0.00001)): Bool =>
        """
        true if two floats are within 'tolerance' of each other, false otherwise.

        Necessary due to floating point precision issues... 
        """
        (x - y).abs() <= tolerance