export
    Projectile,
    propagate,
    closest_time_of_approach,
    closest_approach_distance,
    closest_time_of_approach_and_distance

immutable Projectile
    pos::VecSE2 # position (x,y,θ)
    v::Float64  # speed
end

propagate(P::Projectile, Δt::Float64) = Projectile(P.pos + polar(P.v*Δt, P.pos.θ), P.v)
"""
The time at which two projectiles are closest to one another
A negative value indicates that this occurred in the past.
see: http://geomalgorithms.com/a07-_distance.html
"""
function closest_time_of_approach(A::Projectile, B::Projectile)

    W = convert(VecE2, A.pos - B.pos)
    Δ = polar(A.v, A.pos.θ) - polar(B.v, B.pos.θ)
    aΔ = abs2(Δ)

    if aΔ ≈ 0.0
        return 0.0
    else
        return -dot(W, Δ) / aΔ
    end
end
function closest_approach_distance(A::Projectile, B::Projectile, t_CPA::Float64=closest_time_of_approach(A, B))
    Aₜ = convert(VecE2, propagate(A, t_CPA).pos)
    Bₜ = convert(VecE2, propagate(B, t_CPA).pos)
    return abs(Aₜ - Bₜ)
end
function closest_time_of_approach_and_distance(A::Projectile, B::Projectile)
    t_CPA = closest_time_of_approach(A, B)
    d_CPA = closest_approach_distance(A, B, t_CPA)
    return (t_CPA, d_CPA)
end