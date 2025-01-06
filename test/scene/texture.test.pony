use "pony_test"

use "../../src/parsers"
use "../../src/scene"

class iso TextureTests is TestList
    """
    Tests for Texture class.
    """
    new create(env: Env) => PonyTest(env, this)

    new make() => None

    fun tag tests(test: PonyTest) =>
        test(_TestTextureSamplingSimple)
        test(_TestTextureSamplingComplex)
        test(_TestTextureSamplingOutOfBounds)


class iso _TestTextureSamplingSimple is UnitTest
    fun name(): String => "Texture Sampling Simple"

    fun apply(h: TestHelper) =>
        // Setting up a 2x2 grid of pixels: 
        // RED, GREEN
        // BLUE, BLACK
        let pixels: Array[Array[(U8, U8, U8)] val] val = 
            [
                [(255, 0, 0); (0, 255, 0)]
                [(0, 0, 255); (0, 0, 0)]
            ]
        
        let texture: Texture = Texture(pixels, 2, 2)
        try h.assert_true(_TextureTestHelpers.compareTuples[U8](pixels(0)?(0)?, texture.sample(0, 0)?)) else h.fail() end
        try h.assert_true(_TextureTestHelpers.compareTuples[U8](pixels(0)?(1)?, texture.sample(1, 0)?)) else h.fail() end
        try h.assert_true(_TextureTestHelpers.compareTuples[U8](pixels(1)?(0)?, texture.sample(0, 1)?)) else h.fail() end
        try h.assert_true(_TextureTestHelpers.compareTuples[U8](pixels(1)?(1)?, texture.sample(1, 1)?)) else h.fail() end
        

class iso _TestTextureSamplingComplex is UnitTest
    fun name(): String => "Texture Sampling Complex"

    fun apply(h: TestHelper) =>
        let pixels: Array[Array[(U8, U8, U8)] val] val =
            [
                [(255, 0, 0); (255, 127, 0); (255, 255, 0); (127, 255, 0); (0, 255, 0)] // Row 0 (top)
                [(0, 255, 127); (0, 255, 255); (0, 127, 255); (0, 0, 255); (127, 0, 255)] // Row 1
                [(255, 0, 255); (255, 0, 127); (127, 0, 0); (127, 127, 127); (127, 255, 255)] // Row 2
                [(0, 127, 127); (0, 127, 0); (127, 127, 0); (255, 127, 127); (255, 255, 127)] // Row 3
                [(127, 255, 127); (127, 127, 255); (255, 127, 255); (255, 0, 255); (127, 0, 127)] // Row 4 (bottom)
            ]

        let texture: Texture = Texture(pixels, 5, 5)
        try h.assert_true(_TextureTestHelpers.compareTuples[U8](pixels(0)?(0)?, texture.sample(0, 0)?)) else h.fail() end
        try h.assert_true(_TextureTestHelpers.compareTuples[U8](pixels(0)?(0)?, texture.sample(0.15, 0.15)?)) else h.fail() end
        try h.assert_true(_TextureTestHelpers.compareTuples[U8](pixels(4)?(4)?, texture.sample(1, 1)?)) else h.fail() end

class iso _TestTextureSamplingOutOfBounds is UnitTest
    fun name(): String => "Texture Sampling Out Of Bounds"

    fun apply(h: TestHelper) =>
        let pixels: Array[Array[(U8, U8, U8)] val] val =
            [
                [(255, 0, 0); (255, 127, 0); (255, 255, 0); (127, 255, 0); (0, 255, 0)] // Row 0 (top)
                [(0, 255, 127); (0, 255, 255); (0, 127, 255); (0, 0, 255); (127, 0, 255)] // Row 1
                [(255, 0, 255); (255, 0, 127); (127, 0, 0); (127, 127, 127); (127, 255, 255)] // Row 2
                [(0, 127, 127); (0, 127, 0); (127, 127, 0); (255, 127, 127); (255, 255, 127)] // Row 3
                [(127, 255, 127); (127, 127, 255); (255, 127, 255); (255, 0, 255); (127, 0, 127)] // Row 4 (bottom)
            ]
        let texture: Texture = Texture(pixels, 5, 5)

        h.assert_error({(): None? => texture.sample(-1, -1)? })
        h.assert_error({(): None? => texture.sample(3, 0.4)? })
        h.assert_no_error({(): None? => texture.sample(0.5, 0.4)? })

primitive _TextureTestHelpers
    fun compareTuples[A: Equatable[A] #read](expect: (A, A, A), actual: (A, A, A)): Bool =>
        """
        Ensure that two tuples have the same elements...
        """
        (expect._1 == actual._1) and (expect._2 == actual._2) and (expect._3 == actual._3)