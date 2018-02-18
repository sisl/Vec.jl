export
    Quat,
    get_axis,
    get_rotation_angle,

    RPY

struct Quat <: FieldVector{4, Float64}
    x::Float64
    y::Float64
    z::Float64
    w::Float64
end

Base.show(io::IO, q::Quat) = @printf(io, "QUAT({%6.3f, %6.3f, %6.3f}, %6.3f)", q.x, q.y, q.z, q.w)

function get_axis(q::Quat)

    θ = 2*atan2(sqrt(q.x*q.x + q.y*q.y + q.z*q.z), q.w)
    h = sin(θ/2)

    x = q.x / h
    y = q.y / h
    z = q.z / h

    VecE3(x, y, z)
end
get_rotation_angle(q::Quat) = 2.0*acos(q.w)

"""
Roll Pitch Yaw
"""
struct RPY <: FieldVector{3, Float64}
    r::Float64
    p::Float64
    y::Float64
end
function Base.convert(::Type{RPY}, q::Quat)

    q2 = normalized(q)
    x = q.x
    y = q.y
    z = q.z
    w = q.w

    roll  = atan2(y*z+w*x, 0.5-x^2-y^2)
    pitch = asin(-2*(x*z + w*y))
    yaw   = atan2(x*y+w*z, 0.5-y^2-z^2)

    RPY(roll, pitch, yaw)
end
function Base.convert(::Type{Matrix{Float64}}, quat::Quat)

    # convert it to a rotation matrix

    w = quat.w
    x = quat.x
    y = quat.y
    z = quat.z

    n = w * w + x * x + y * y + z * z
    s = (n == 0.0) ? 0.0 : 2.0 / n
    wx = s * w * x; wy = s * w * y; wz = s * w * z
    xx = s * x * x; xy = s * x * y; xz = s * x * z
    yy = s * y * y; yz = s * y * z; zz = s * z * z

    [ 1 - (yy + zz)         xy - wz          xz + wy;
           xy + wz     1 - (xx + zz)         yz - wx;
           xz - wy          yz + wx     1 - (xx + yy) ]
end
