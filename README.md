# Vec

Provides 2D and 3D vector types for vector operations in Julia.

[![Build Status](https://travis-ci.org/tawheeler/Vec.jl.svg?branch=master)](https://travis-ci.org/tawheeler/Vec.jl)
[![Coverage Status](https://coveralls.io/repos/tawheeler/Vec.jl/badge.svg)](https://coveralls.io/r/tawheeler/Vec.jl)

# Git It

```julia
Pkg.clone("https://github.com/tawheeler/Vec.jl.git")
```

# Usage

`Vec.jl` provides several vector types, named after their groups. All types are immutable.

* `VecE2` provides an (x,y) type of the Euclidean-2 group.
* `VecE3` provides an (x,y,z) type of the Euclidean-3 group.
* `VecSE2` provides an (x,y,theta) type of the special-euclidean 2 group.

```julia
v = VecE2(0, 1)
v = VecSE2(0,1,0.5)
v = VecE3(0, 1, 2)
```

Vector math works as one expects:

```
u = v + 2
u = v * 2
v = cross(v, VecE2(0.4, 5.0))
hypot(v)
```
