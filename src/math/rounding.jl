Base.round(x::FloatD64) = round(x, RoundNearest)
Base.round(::Type{T}, x::FloatD64) where {T<:Integer} = T(round(x, RoundNearest))

function Base.round(x::FloatD64, ::RoundingMode{:Up})
    return ceil(x)
end
Base.round(::Type{T}, x::FloatD64, ::RoundingMode{:Up}) where {T<:Integer} = T(round(x, RoundUp))


function Base.round(x::FloatD64, ::RoundingMode{:Down})
    return floor(x)
end
Base.round(::Type{T}, x::FloatD64, ::RoundingMode{:Down}) where {T<:Integer} = T(round(x, RoundDown))

function Base.round(x::FloatD64, ::RoundingMode{:ToZero})
    return signbit(x) ? ceil(x) : floor(x)
end
Base.round(::Type{T}, x::FloatD64, ::RoundingMode{:ToZero}) where {T<:Integer} = T(round(x, RoundToZero))

function Base.round(x::FloatD64, ::RoundingMode{:RoundFromZero})
    return signbit(x) ? floor(x) : ceil(x)
end
Base.round(::Type{T}, x::FloatD64, ::RoundingMode{:FromZero}) where {T<:Integer} = T(round(x, RoundFromZero))

function Base.round(x::FloatD64, ::RoundingMode{:Nearest})
    signbit(x) && return -round(-x, RoundNearest)
    a = trunc(x + 0.5)
    return iseven(a) ? a : trunc(x - 0.5)
end
Base.round(::Type{T}, x::FloatD64, ::RoundingMode{:Nearest}) where {T<:Integer} = T(round(x, RoundNearest))

function Base.round(x::FloatD64, ::RoundingMode{:NearestTiesAway})
    signbit(x) && return -round(-x, RoundNearestTiesAway)
    !isinteger(x - 0.5) && return round(x, RoundNearest)
    return round(x + 0.5, RoundNearest)
end
Base.round(::Type{T}, x::FloatD64, ::RoundingMode{:NearestTiesAway}) where {T<:Integer} = T(round(x, RoundNearestTiesAway))

function Base.round(x::FloatD64, ::RoundingMode{:NearestTiesUp})
    signbit(x) && return -round(-x, RoundNearestTiesUp)
    !isinteger(x - 0.5) && return round(x, RoundUp)
    return round(x + 0.5, RoundNearest)
end
Base.round(::Type{T}, x::FloatD64, ::RoundingMode{:NearestTiesUp}) where {T<:Integer} = T(round(x, RoundNearestTiesUp))
