VERSION >= v"0.4.0-dev+6521" && __precompile__(true)

module Vec

using Compat

export
    AbstractVec,
    VecE,  # an abstract euclidean-group vector
    VecSE, # an abstract special euclidean-group element

    VecE2, # two-element Float64 vector, {x, y}
    VecE3, # three-element Float64 vector, {x, y, z}
    VecSE2, # point in special euclidean group of order 2, {x, y, θ}

    polar, # construct a polar vector with (r,θ)

    proj,  # vector projection
           # proj(a::vec, b::vec, ::Type{Float64}) will do scalar projection of a onto b
           # proj(a::vec, b::vec, ::Type{Vec}) will do vector projection of a onto b

    lerp,  # linear interpolation between two vec's
    lerp_angle,

    dist,  # scalar distance between two vec's
    dist2, # squared scalar distance between two vec's

    rot,   # rotate the vector, always using the Right Hand Rule
    rot_normalized, # like rot, but assumes axis is normalized

    deltaangle, # signed delta angle
    angledist,  # distance between two angles

    inertial2body,
    body2inertial,

    are_collinear,
    get_intersection,

    Circ,
    AABB,
    OBB

abstract AbstractVec
abstract VecE <: AbstractVec
abstract VecSE <: AbstractVec

lerp(a::Real, b::Real, t::Real) = a + (b-a)*t

include("vecE2.jl")
include("vecE3.jl")
include("vecSE2.jl")

function Base.isapprox(a::VecE, b::VecE;
    _absa::Float64 = abs(a),
    _absb::Float64 = abs(b),
    _maxeps::Float64 = max(eps(_absa), eps(_absb)),
    rtol::Real=cbrt(_maxeps),
    atol::Real=sqrt(_maxeps)
    )

    dist2(a, b) <= atol + rtol*max(_absa, _absb)
end
lerp(a::Real, b::Real, t::AbstractFloat) = a + (b-a)*t

include("geom/geom.jl")
include("coordinate_transforms.jl")
include("quat.jl")

end # module
