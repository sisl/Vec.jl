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
    closest_time_of_approach_and_distance

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