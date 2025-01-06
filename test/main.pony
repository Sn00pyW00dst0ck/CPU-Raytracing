use "pony_test"

use parser_tests = "./parsers"
use scene_tests = "./scene"

actor Main is TestList
	new create(env: Env) => PonyTest(env, this)
	new make() => None

	fun tag tests(test: PonyTest) =>
        parser_tests.PPMFileParserTests.make().tests(test)
		scene_tests.TriangleTests.make().tests(test)
		scene_tests.TextureTests.make().tests(test)
		
        
