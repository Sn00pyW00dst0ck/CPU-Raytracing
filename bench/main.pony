use "files"
use "pony_bench"
use "promises"

use "../src"
use "../src/scene"

use "./math"

actor Main is BenchmarkList
    let _env: Env

    new create(env: Env) =>
        _env = env
        PonyBench(env, this)

    fun tag benchmarks(bench: PonyBench) =>
        VectorBenchmarks.benchmarks(bench)
        RayBenchmarks.benchmarks(bench)
        custom_benchmarks(bench)

    // A behavior can be called from a 'fun tag', and has access to fields, so use that to setup benchmarks that need 'Env' access
    be custom_benchmarks(bench: PonyBench) =>
        bench(_OBJFileParser(_env, "suzanne.obj"))

class iso _OBJFileParser is AsyncMicroBenchmark
    """
    Asynchronous benchmark for the OBJ file parsing process.
    """
    let _env: Env
    let _file_name: String
    let _path: FilePath

    new iso create(env: Env, file_name: String) =>
        _env = env
        _file_name = file_name
        _path = FilePath(FileAuth(_env.root), "../assets/" + file_name)

    fun name(): String =>
      "ObjFileParser(\"" + _file_name.string() + "\")"

    fun apply(c: AsyncBenchContinue) =>
        // Using type 'Any' is slightly bad, but we don't care about the result here so its fine.
        let p: Promise[Mesh val] = Promise[Mesh val]
        p.next[Any](
            {(value: Mesh val) => c.complete() },
            {() => c.fail() }
        )

        ObjFileParser(_path, p)
