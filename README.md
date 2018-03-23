# Vec

Provides 2D and 3D vector types for vector operations in Julia.

[![Build Status](https://travis-ci.org/sisl/Vec.jl.svg?branch=master)](https://travis-ci.org/sisl/Vec.jl)
[![Coverage Status](https://coveralls.io/repos/sisl/Vec.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/sisl/Vec.jl?branch=master)

# Git It

```julia
Pkg.clone("https://github.com/sisl/Vec.jl.git")
```

# Usage

`Vec.jl` provides several vector types, named after their groups. All types are immutable and are subtypes of ['StaticArrays'](https://github.com/JuliaArrays/StaticArrays.jl)' `FieldVector`, so they can be indexed and used as vectors in many contexts.

* `VecE2` provides an (x,y) type of the Euclidean-2 group.
* `VecE3` provides an (x,y,z) type of the Euclidean-3 group.
* `VecSE2` provides an (x,y,theta) type of the special-Euclidean 2 group.

```julia
v = VecE2(0, 1)
v = VecSE2(0,1,0.5)
v = VecE3(0, 1, 2)
```

Additional geometry types include `Quat` for quaternions, `Line`, `LineSegment`, and `Projectile`.

The switch to StaticArrays brings several breaking changes. If you need a backwards-compatible version, please checkout the `v0.1.0` tag with ```cd(Pkg.dir("Vec")); run(`git checkout v0.1.0`)```.
