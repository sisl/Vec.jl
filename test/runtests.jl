using Vec
using Base.Test

@test invlerp(0.0,1.0,0.5) ≈ 0.5
@test invlerp(0.0,1.0,0.4) ≈ 0.4
@test invlerp(0.0,1.0,0.7) ≈ 0.7
@test invlerp(10.0,20.0,12.0) ≈ 0.2


include("test_vecE2.jl")
include("test_vecE3.jl")
include("test_vecSE2.jl")
include("test_quat.jl")

include("test_coordinate_transforms.jl")
include("test_geomE2.jl")

include("test_diff.jl")
