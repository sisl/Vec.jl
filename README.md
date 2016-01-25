# Vec

Provides 2D and 3D vector types for vector operations in Julia.

```julia
v = VecE2(0, 1) # x,y type (Euclidean-2 group)
v = VecSE2(0,1,0.5) # x,y,theta type (special-order 2 group)
v = VecE3(0, 1, 2) # x,y,z type (Euclean-3 group)

u = v + 2
u = v * 2
v = cross(v, VecE2(0.4, 5.0))
```


[![Build Status](https://travis-ci.org/tawheeler/Vec.jl.svg?branch=master)](https://travis-ci.org/tawheeler/Vec.jl)
[![Coverage Status](https://coveralls.io/repos/tawheeler/Vec.jl/badge.svg)](https://coveralls.io/r/tawheeler/Vec.jl)
