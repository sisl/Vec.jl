const DUMMY_PRECISION = 1e-12

Base.isfinite(a::AbstractVec) = all(isfinite.(a))
Base.isinf(a::AbstractVec) = any(isinf.(a))

function StaticArrays.similar_type(::Type{V}, ::Type{F}, size::Size) where {V<:AbstractVec, F<:AbstractFloat}
    # TODO: implement this for other types
    if size == Size(V) && eltype(V) == F
        return V
    else
        error("StaticArrays.similar_type is not yet implemented for Vec except for Float64 and matching size.")
    end
end

Base.abs(a::AbstractVec) = error("abs(v::AbstractVec) has been removed. Use norm(v) to get the norm; abs.(v) to get the element-wise absolute value.")
