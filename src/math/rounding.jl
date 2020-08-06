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

Base.round(x::FloatD64; digits::Integer=0, sigdigits::Integer=0, base = 10) = FloatD64(round(Float128(x); digits=digits, sigdigits=sigdigits, base=base))
Base.round(x::FloatD64, r::RoundingMode=RoundingMode{:Nearest}; digits::Integer=0, sigdigits::Integer=0, base = 10) = FloatD64(round(Float128(x), r; digits=digits, sigdigits=sigdigits, base=base))

#=

  round([T,] x, [r::RoundingMode])
  round(x, [r::RoundingMode]; digits::Integer=0, base = 10)
  round(x, [r::RoundingMode]; sigdigits::Integer, base = 10)

  Rounds the number x.

  Without keyword arguments, x is rounded to an integer value, returning a value of type T, or of the same type of x
  if no T is provided. An InexactError will be thrown if the value is not representable by T, similar to convert.

  If the digits keyword argument is provided, it rounds to the specified number of digits after the decimal place (or
  before if negative), in base base.

  If the sigdigits keyword argument is provided, it rounds to the specified number of significant digits, in base
  base.

  The RoundingMode r controls the direction of the rounding; the default is RoundNearest, which rounds to the nearest
  integer, with ties (fractional values of 0.5) being rounded to the nearest even integer. Note that round may give
  incorrect results if the global rounding mode is changed (see rounding).
=#
