# CPU-Raytracing

This is an attempt to create a high-performance CPU based raytracer. Obviously, no raytracer that is CPU based will reach the same level of performance as one based on GPU hardware, but this was more of an experiment to see how far I could push the boundaries of parallelism and raytracing seemed a good candidate for that. 

## Setup 

To setup the project, have the PONY programming language installed in your environment. Then run tehe `corral update` command from the root directory. 

To build and execute the main program:
```
cd src
corral run -- ponyc
./src
```

To build and execute the unit tests:
```
cd test
corral run -- ponyc
./test
```

To build and execute the benchmarks:
```
cd bench
corral run -- ponyc
./bench
```

## Results

Testing with the pipeline thus far shows that approximately ~3 seconds of real time are needed to raytrace the 'suzanne' model (with a texture applied to it) to a 1600x1200 image, while the CPU spends ~24 seconds processing the calculations. This indicates that approximately 8 CPU cores are effectively utilized at once. 


## Future Development Plans

Future development goals for this project are to utilize BVH and similar optimizations to improve performance, to support a more feature rich material and lighting system, to support output and input from more file types, and to further benchmark and test the various program parts for correctness and speed. 