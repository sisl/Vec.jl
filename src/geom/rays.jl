export
    Ray,
    intersects      # true if A and B intersect


const Ray = VecSE2 # has an origin and an orientation
function intersects(A::Ray, B::Ray)
    as = convert(VecE2, A)
    bs = convert(VecE2, B)
    ad = polar(1.0, A.θ)
    bd = polar(1.0, B.θ)

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

"""
returns VecE2 of where intersection occurs, and VecE2(NaN,NaN) otherwise
"""
function Base.intersect(A::VecSE2, B::VecSE2)

    as = convert(VecE2, A)
    bs = convert(VecE2, B)
    ad = polar(1.0, A.θ)
    bd = polar(1.0, B.θ)

    dx = bs.x - as.x
    dy = bs.y - as.y
    det = bd.x * ad.y - bd.y * ad.x
    if !(det ≈ 0.0) # no intersection
        u = (dy * bd.x - dx * bd.y) / det
        v = (dy * ad.x - dx * ad.y) / det
        if u > 0.0 && v > 0.0
            return as + u*ad
        end
    end

    # TODO - if det == 0 could be the case that they are colinear, and the first point of intersection should be taken

    return VecE2(NaN,NaN) # no intersection
end