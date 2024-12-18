use "files"
use "pony_bench"
use "promises"

use "../src"

use "./math"

actor Main is BenchmarkList
    var env: Env
    new create(env': Env) =>
        env = env'
        PonyBench(env', this)

    fun tag benchmarks(bench: PonyBench) =>
        VectorBenchmarks.benchmarks(bench)
        RayBenchmarks.benchmarks(bench)
        // bench(_OBJFileParser(env, "head.obj")) // TODO: figure out how to link in the 'env' here because this is a tag function...

class iso _OBJFileParser is AsyncMicroBenchmark
    """
    Asynchronous benchmark for the OBJ file parsing process.
    """
    let _file_name: String
    let _path: FilePath

    new iso create(env: Env, file_name: String) =>
        _file_name = file_name
        _path = FilePath(FileAuth(env.root), "../assets/" + file_name)

    fun name(): String =>
      "ObjFileParser(" + _file_name.string() + ")"

    fun apply(c: AsyncBenchContinue) =>
        // Using type 'Any' is slightly bad, but we don't care about the result here so its fine.
        let p: Promise[Any] = Promise[Any]
        p.next[Any](
            {(value: Any) => c.complete() },
            {() => c.fail() }
        )

        ObjFileParser(_path, p)
