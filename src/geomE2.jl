#=
Geometry in 2d euclidean space
=#

"""
deltaangle(a::Real, b::Real)

Return the minimum δ such that
    a + δ = mod(b, 2π)
"""
deltaangle(a::Real, b::Real) = atan2(sin(b-a), cos(b-a))

# distance between two angles
angledist( a::Real, b::Real ) = abs(deltaangle(a,b))

# linear interpolation between angles
lerp_angle(a::Real, b::Real, t::AbstractFloat) = a + deltaangle(a, b)*t

# true if the values are collinear within a tolerance
function are_collinear(a::AbstractVec, b::AbstractVec, c::AbstractVec, tol::Float64=1e-8)
    # http://mathworld.wolfram.com/Collinear.html
    # if val = 0 then they are collinear
    val = a.x*(b.y-c.y) + b.x*(c.y-a.y)+c.x*(a.y-b.y)
    abs(val) < tol
end

function inertial2body(point::VecE2, reference::VecSE2)

    #=
    Convert a point in an inertial cartesian coordinate frame
    to be relative to a body's coordinate frame

    The body's position is given relative to the same inertial coordinate frame
    =#

    s, c = sin(reference.θ), cos(reference.θ)
    Δx = point.x - reference.x
    Δy = point.y - reference.y
    VecE2(c*Δx + s*Δy, c*Δy - s*Δx)
end
function inertial2body(point::VecSE2, reference::VecSE2)

    #=
    Convert a point in an inertial cartesian coordinate frame
    to be relative to a body's coordinate frame

    The body's position is given relative to the same inertial coordinate frame
    =#

    s, c = sin(reference.θ), cos(reference.θ)
    Δx = point.x - reference.x
    Δy = point.y - reference.y
    VecSE2(c*Δx + s*Δy, c*Δy - s*Δx, point.θ - reference.θ)
end
function body2inertial(point::VecE2, reference::VecSE2)

    #=
    Convert a point in a body-relative cartesian coordinate frame
    to be relative to a the inertial coordinate frame the body is described by
    =#

    c, s = cos(reference.θ), sin(reference.θ)
    VecE2(c*point.x -s*point.y + reference.x, s*point.x +c*point.y + reference.y)
end
function body2inertial(point::VecSE2, reference::VecSE2)

    #=
    Convert a point in a body-relative cartesian coordinate frame
    to be relative to a the inertial coordinate frame the body is described by
    =#

    c, s = cos(reference.θ), sin(reference.θ)
    VecSE2(c*point.x -s*point.y + reference.x, s*point.x +c*point.y + reference.y, reference.θ + point.θ)
end

export
    ray_future_position,
    closest_time_of_approach_ray_ray,
    closest_approach_distance_ray_ray,
    closest_time_of_approach_and_distance,
    intersects,      # true if A and B intersect
    get_intersection # returns VecE2 of where intersection occurs, and VecE2(NaN,NaN) otherwise

ray_future_position(P::VecSE2, v::Float64, Δt::Float64) = (convert(VecE2, P) + polar(v*Δt, P.θ))::VecE2
function closest_time_of_approach_ray_ray(P::VecSE2, u::Float64, Q::VecSE2, v::Float64)

    # the time at which the two rays are closest to one another
    # a negative value indicates that this occurred in the past
    # see: http://geomalgorithms.com/a07-_distance.html

    W = convert(VecE2, P) - convert(VecE2, Q)
    Δ = polar(u, P.θ) - polar(v, Q.θ)
    aΔ = abs2(Δ)

    if aΔ == 0.0
        0.0
    else
        -dot(W, Δ) / abs2(Δ)
    end
end
function closest_approach_distance_ray_ray(P::VecSE2, u::Float64, Q::VecSE2, v::Float64, t_CPA::Float64=closest_time_of_approach_ray_ray(P, u, Q, v))
    Pf = ray_future_position(P, u, t_CPA)
    Qf = ray_future_position(Q, v, t_CPA)
    abs(Pf - Qf)
end
function closest_time_of_approach_and_distance(P::VecSE2, u::Float64, Q::VecSE2, v::Float64)
    t_CPA = closest_time_of_approach_ray_ray(P, u, Q, v)
    d_CPA = closest_approach_distance_ray_ray(P, u, Q, v, t_CPA)
    (t_CPA, d_CPA)
end
function intersects(rayA::VecSE2, rayB::VecSE2)
    as = convert(VecE2, rayA)
    bs = convert(VecE2, rayB)
    ad = polar(1.0, rayA.θ)
    bd = polar(1.0, rayB.θ)

    dx = bs.x - as.x
    dy = bs.y - as.y
    det = bd.x * ad.y - bd.y * ad.x

    if det == 0.0
        return false
    end

    u = (dy * bd.x - dx * bd.y) / det
    v = (dy * ad.x - dx * ad.y) / det
    return u > 0.0 && v > 0.0
end
function get_intersection(rayA::VecSE2, rayB::VecSE2)

    as = convert(VecE2, rayA)
    bs = convert(VecE2, rayB)
    ad = polar(1.0, rayA.θ)
    bd = polar(1.0, rayB.θ)

    dx = bs.x - as.x
    dy = bs.y - as.y
    det = bd.x * ad.y - bd.y * ad.x
    if det != 0.0 # no intersection
        u = (dy * bd.x - dx * bd.y) / det
        v = (dy * ad.x - dx * ad.y) / det
        if u > 0.0 && v > 0.0
            return as + u*ad
        end
    end

    # TODO - if det == 0 could be the case that they are colinear, and the first point of intersection should be taken

    VecE2(NaN,NaN) # no intersection
end

export
    Circ,
    AABB,
    AABB_center_length_width,
    OBB

immutable Circ{V<:AbstractVec}
    c::V # center
    r::Float64 # radius
end
Circ(x::Real, y::Real, r::Real) = Circ{VecE2}(VecE2(x, y), r)
Circ(x::Real, y::Real, z::Real, r::Real) = Circ{VecE3}(VecE3(x, y, z), r)

@compat Base.:+(circ::Circ{VecE2}, v::VecE2) = Circ{VecE2}(circ.c + v, circ.r)
@compat Base.:-(circ::Circ{VecE2}, v::VecE2) = Circ{VecE2}(circ.c - v, circ.r)

Base.contains{V}(circ::Circ{V}, p::V) = abs2(circ.c - p) ≤ circ.r*circ.r
inertial2body(circ::Circ{VecE2}, reference::VecSE2) = Circ{VecE2}(inertial2body(circ.c, reference), circ.r)

# Axis-Aligned Bounding Box
immutable AABB
    center::VecE2
    len::Float64 # length along x axis
    wid::Float64 # width along y axis
end
function AABB(bot_left::VecE2, top_right::VecE2)
    center = (bot_left + top_right)/2
    Δ = top_right - bot_left
    return AABB(center, abs(Δ.x), abs(Δ.y))
end

@compat Base.:+(box::AABB, v::VecE2) = AABB(box.center + v, box.len, box.wid)
@compat Base.:-(box::AABB, v::VecE2) = AABB(box.center - v, box.len, box.wid)

function Base.contains(box::AABB{VecE2}, P::VecE2)
    box.bot_left.x ≤ P.x ≤ box.top_right.x &&
    box.bot_left.y ≤ P.y ≤ box.top_right.y
end


# Oriented Bounding Box
immutable OBB
    aabb::AABB
    θ::Float64
end
function OBB(center::VecE2, len::Float64, wid::Float64, θ::Float64)
    del = VecE2(len/2, wid/2)
    bot_left = center - del
    top_right = center + del
    OBB(AABB(bot_left, top_right), θ)
end
OBB(center::VecSE2, len::Float64, wid::Float64) = OBB(convert(VecE2, center), len, wid, center.θ)

@compat Base.:+(box::OBB, v::VecE2) = OBB(box.aabb+v, box.θ)
@compat Base.:-(box::OBB, v::VecE2) = OBB(box.aabb-v, box.θ)

function Base.contains(box::OBB, P::VecE2)
    C = 0.5*(box.aabb.bot_left + box.aabb.top_right)
    contains(box.aabb, rot(P-C, -box.θ)+C)
end

function inertial2body(box::OBB, reference::VecSE2)
    c = (box.aabb.bot_left + box.aabb.top_right)/2
    c = VecSE2(c.x, c.y, box.θ)
    c′ = inertial2body(c, reference)
    len = box.aabb.top_right.x - box.aabb.bot_left.x
    wid = box.aabb.top_right.y - box.aabb.bot_left.y
    OBB(c′, len, wid)
end
