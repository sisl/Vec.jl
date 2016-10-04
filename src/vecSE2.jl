#=
VecSE2: a 2d euclidean vector with an orientation
=#

immutable VecSE2 <: VecSE
    x :: Float64
    y :: Float64
    θ :: Float64

    VecSE2(x::Real=0.0, y::Real=0.0, θ::Real=0.0) = new(x, y, θ)
    VecSE2(a::VecE2, θ::Real=0.0) = new(a.x, a.y, θ)
end

polar(r::Real, ϕ::Real, θ::Real) = VecSE2(r*cos(ϕ), r*sin(ϕ), θ)

Base.length(::VecSE2) = 3
Base.copy(a::VecSE2) = VecSE2(a.x, a.y, a.θ)
Base.convert(::Type{Vector{Float64}}, a::VecSE2) = [a.x, a.y, a.θ]
Base.convert(::Type{VecE3}, a::VecSE2) = VecE3(a.x, a.y, a.θ)
Base.convert(::Type{VecE2}, a::VecSE2) = VecE2(a.x, a.y)
function Base.convert{R<:Real}(::Type{VecSE2}, a::AbstractArray{R})
    @assert(length(a) == 3)
    VecSE2(a[1], a[2], a[3])
end
Base.show(io::IO, a::VecSE2) = @printf(io, "VecSE2({%.3f, %.3f}, %.3f)", a.x, a.y, a.θ)

@compat Base.:+(b::Real, a::VecSE2) = VecSE2(a.x+b, a.y+b, a.θ)
@compat Base.:+(a::VecSE2, b::Real) = VecSE2(a.x+b, a.y+b, a.θ)
@compat Base.:+(a::VecSE2, b::VecE2) = VecSE2(a.x+b.x, a.y+b.y, a.θ)
@compat Base.:+(a::VecSE2, b::VecSE2) = VecSE2(a.x+b.x, a.y+b.y, a.θ+b.θ)

@compat Base.:-(b::Real, a::VecSE2) = VecSE2(b-a.x, b-a.y, a.θ)
@compat Base.:-(a::VecSE2, b::Real) = VecSE2(a.x-b, a.y-b, a.θ)
@compat Base.:-(a::VecSE2, b::VecE2) = VecSE2(a.x-b.x, a.y-b.y, a.θ)
@compat Base.:-(a::VecE2,  b::VecSE2) = VecE2(a.x-b.x, a.y-b.y)
@compat Base.:-(a::VecSE2, b::VecSE2) = VecSE2(a.x-b.x, a.y-b.y, a.θ-b.θ)

@compat Base.:*(b::Real, a::VecSE2) = VecSE2(b*a.x, b*a.y, a.θ)
@compat Base.:*(a::VecSE2, b::Real) = VecSE2(a.x*b, a.y*b, a.θ)

@compat Base.:/(a::VecSE2, b::Real) = VecSE2(a.x/b, a.y/b, a.θ)

@compat Base.:^(a::VecSE2, b::Integer) = VecSE2(a.x^b, a.y^b, a.θ)
@compat Base.:^(a::VecSE2, b::AbstractFloat) = VecSE2(a.x^b, a.y^b, a.θ)

@compat Base.:%(a::VecSE2, b::Real) = VecSE2(a.x%b, a.y%b, a.θ)

Base.clamp(a::VecSE2, lo::Real, hi::Real) = VecSE2(clamp(a.x, lo, hi), clamp(a.y, lo, hi), a.θ)

@compat Base.:(==)(a::VecSE2, b::VecSE2) = isequal(a.x, b.x) && isequal(a.y, b.y) && isequal(a.θ, b.θ)
Base.isequal(a::VecSE2, b::VecSE2) = isequal(a.x, b.x) && isequal(a.y, b.y) && isequal(a.θ, b.θ)
function Base.isapprox(a::VecSE2, b::VecSE2;
    _absa::Float64 = abs(a),
    _absb::Float64 = abs(b),
    _maxeps::Float64 = max(eps(_absa), eps(_absb)),
    rtol::Real=cbrt(_maxeps),
    atol::Real=sqrt(_maxeps)
    )

    isapprox(VecE2(a.x, a.y), VecE2(b.x, b.y), _absa=_absa, _absb=_absb, _maxeps=_maxeps, rtol=rtol, atol=atol) &&
    isapprox(a.θ, b.θ, rtol=rtol, atol=atol)
end

Base.isfinite(a::VecSE2) = isfinite(a.x) && isfinite(a.y) && isfinite(a.θ)
Base.isinf(a::VecSE2) = isinf(a.x) || isinf(a.y) || isinf(a.θ)
Base.isnan(a::VecSE2) = isnan(a.x) || isnan(a.y) || isnan(a.θ)

Base.abs(a::VecSE2) = hypot(a.x, a.y)
Base.hypot(a::VecSE2) = hypot(a.x, a.y)
Base.abs2(a::VecSE2) = a.x*a.x + a.y*a.y
function Base.norm(a::VecSE2)
    m = abs(a)
    VecSE2(a.x/m, a.y/m)
end

Base.atan2(a::VecSE2) = atan2(a.y, a.x)

function lerp(a::VecSE2, b::VecSE2, t::Real)
    x = a.x + (b.x-a.x)*t
    y = a.y + (b.y-a.y)*t
    θ = lerp_angle(a.θ, b.θ, t)
    VecSE2(x, y, θ)
end

Base.rot180(a::VecSE2) = VecSE2(a.x, a.y, a.θ+π)
Base.rotl90(a::VecSE2) = VecSE2(a.x, a.y, a.θ+0.5π)
Base.rotr90(a::VecSE2) = VecSE2(a.x, a.y, a.θ-0.5π)
rot(a::VecSE2, Δθ::Float64) = VecSE2(a.x, a.y, a.θ+Δθ)

Base.mod2pi(a::VecSE2) = VecSE2(a.x, a.y, mod2pi(a.θ))