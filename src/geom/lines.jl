export
    Line,
    get_polar_angle,
    get_distance,
    get_side

immutable Line
    A::VecE2
    B::VecE2
end
Base.:-(line::Line, V::VecE2) = Line(line.A - V, line.B - V)
Base.:+(line::Line, V::VecE2) = Line(line.A + V, line.B + V)

get_polar_angle(line::Line) = mod2pi(atan2(line.B.y - line.A.y, line.B.x - line.A.x))

"""
The distance between the line and the point P
"""
function get_distance(line::Line, P::VecE2)

    ab = line.B - line.A
    pb = P - line.A

    denom = abs2(ab)
    if denom ≈ 0.0
        return 0.0
    end

    r = dot(ab, pb)/denom
    return abs(P - (line.A + r*ab))
end


"""
What side of the line you are on, based on A → B
Is -1 if on the left, 1 if on the right, and 0 if on the line
"""
get_side(line::Line, p::VecE2) = sign((line.B.x-line.A.x) * (p.y-line.A.y) - (line.B.y-line.A.y) * (p.x-line.A.x))