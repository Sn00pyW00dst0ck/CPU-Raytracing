use "pony_test"

use scene_tests = "./scene"

actor Main is TestList
	new create(env: Env) => PonyTest(env, this)
	new make() => None

	fun tag tests(test: PonyTest) =>
        scene_tests.TriangleTests.make().tests(test)
        
