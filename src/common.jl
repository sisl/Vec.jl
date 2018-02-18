Base.isfinite(a::AbstractVec) = all(isfinite.(a))
Base.isinf(a::AbstractVec) = any(isinf.(a))

function StaticArrays.similar_type(::Type{V}, ::Type{Float64}, size::Size) where {V<:AbstractVec}
    # TODO: implement this for other types
    if size == Size(V) && eltype(V) == Float64
        return V
    else
        error("StaticArrays.similar_type is not yet implemented for Vec except for Float64 and matching size.")
    end
end
