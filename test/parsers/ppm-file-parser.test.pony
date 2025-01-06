use "files"
use "pony_test"
use "promises"
use "time"

use "../../src/parsers"
use "../../src/scene"

class iso PPMFileParserTests is TestList
    """
    Tests for PPMFileParser actor.
    """
    new create(env: Env) => PonyTest(env, this)

    new make() => None

    fun tag tests(test: PonyTest) =>
        test(_TestLoadedHeaderContents)
        test(_TestLoadedPixelContents)
        test(_TestLargePPMFile)


class iso _TestLoadedHeaderContents is UnitTest
    fun name(): String => "PPMFileParser Header Contents"

    fun apply(h: TestHelper) =>
		h.long_test(Nanos.from_seconds(300)) // Give it a max of 300s to complete...

		let test_path = FilePath(FileAuth(h.env.root), Path.abs("./assets/simple.ppm"))

		let p = Promise[Texture val]
		p.next[None](
			{(texture: Texture val) => 
				h.assert_eq[USize](2, texture.width)
				h.assert_eq[USize](3, texture.height)
				h.complete(true)
			},
			{() => 
				h.fail("Error loading  " + Path.abs("./assets/simple.ppm") + " to a Texture.")
				h.complete(false)
			}
		)
		PPMFileParser(test_path, p)

class iso _TestLoadedPixelContents is UnitTest
    fun name(): String => "PPMFileParser Pixel Contents"

    fun apply(h: TestHelper) =>
		h.long_test(Nanos.from_seconds(300)) // Give it a max of 300s to complete...

		let test_path = FilePath(FileAuth(h.env.root), Path.abs("./assets/simple.ppm"))

		let p = Promise[Texture val]
		p.next[None](
			{(texture: Texture val) => 
				// ensure the pixels match the expected

				h.complete(true)
			},
			{() => 
				h.fail("Error loading  " + Path.abs("./assets/simple.ppm") + " to a Texture.")
				h.complete(false)
			}
		)
		PPMFileParser(test_path, p)

class iso _TestLargePPMFile is UnitTest
    fun name(): String => "PPMFileParser Large File"

    fun apply(h: TestHelper) =>
		h.long_test(Nanos.from_seconds(300)) // Give it a max of 300s to complete...

		let test_path = FilePath(FileAuth(h.env.root), Path.abs("./assets/bricks.ppm"))

		let p = Promise[Texture val]
		p.next[None](
			{(texture: Texture val) => 
				h.assert_eq[USize](24, texture.width)
				h.assert_eq[USize](25, texture.height)
				h.complete(true)
			},
			{() => 
				h.fail("Error loading  " + Path.abs("./assets/bricks.ppm") + " to a Texture.")
				h.complete(false)
			}
		)
		PPMFileParser(test_path, p)
