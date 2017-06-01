export
    LineSegment,
    parallel

immutable LineSegment
    A::VecE2
    B::VecE2
end
Base.:+(seg::LineSegment, V::VecE2) = LineSegment(seg.A + V, seg.B + V)
Base.:-(seg::LineSegment, V::VecE2) = LineSegment(seg.A - V, seg.B - V)
Base.convert(::Type{Line}, seg::LineSegment) = Line(seg.A, seg.B)
Base.convert(::Type{LineSegment}, line::Line) = LineSegment(line.A, line.B)

get_polar_angle(seg::LineSegment) = mod2pi(atan2(seg.B.y - seg.A.y, seg.B.x - seg.A.x))

"""
The distance between the line segment and the point P
"""
function get_distance(seg::LineSegment, P::VecE2)

    ab = seg.B - seg.A
    pb = P - seg.A

    denom = abs2(ab)
    if denom == 0.0
        return 0.0
    end

    r = dot(ab, pb)/denom

    if r ≤ 0.0
        abs(P - seg.A)
    elseif r ≥ 1.0
        abs(P - seg.B)
    else
        abs(P - (seg.A + r*ab))
    end
end

"""
What side of the line you are on, based on A → B
"""
get_side(seg::LineSegment, p::VecE2) = sign((seg.B.x-seg.A.x) * (p.y-seg.A.y) - (seg.B.y-seg.A.y) * (p.x-seg.A.x))


"""
The angular distance between the two line segments
"""
function angledist(segA::LineSegment, segB::LineSegment)
    u = segA.B - segA.A
    v = segB.B - segB.A
    sqdenom = abs2(u)*abs2(v)
    if isapprox(sqdenom, 0.0, atol=1e-10)
        return NaN
    end
    return acos(dot(u,v) / sqrt(sqdenom))
end

"""
True if the two segments are parallel
"""
function parallel(segA::LineSegment, segB::LineSegment, ε::Float64=1e-10)
    θ = angledist(segA, segB)
    return isapprox(θ, 0.0, atol=ε)
end