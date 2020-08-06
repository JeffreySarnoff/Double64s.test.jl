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

#=
Base.round(x::FloatD64; digits::Integer=0, base = 10) = FloatD64(round(Float128(x); digits=digits, base=base))
Base.round(x::FloatD64; sigdigits::Integer=0, base = 10) = FloatD64(round(Float128(x); sigdigits=sigdigits, base=base))
Base.round(x::FloatD64, r::RoundingMode; digits=Integer=0, base = 10) = FloatD64(round(Float128(x), r; digits=digits, base=base))
Base.round(x::FloatD64, r::RoundingMode; sigdigits=Integer=0, base = 10) = FloatD64(round(Float128(x), r; sigdigits=sigdigits, base=base))
=#


#=
# NOTE: this relies on the current keyword dispatch behaviour (#9498).
function Base.round(x::FloatD64, r::RoundingMode=RoundNearest;
               digits::Union{Nothing,Integer}=nothing, sigdigits::Union{Nothing,Integer}=nothing, base::Union{Nothing,Integer}=nothing)
    if digits === nothing
        if sigdigits === nothing
            if base === nothing
                # avoid recursive calls
                throw(MethodError(round, (x,r)))
            else
                round(x,r)
                # or throw(ArgumentError("`round` cannot use `base` argument without `digits` or `sigdigits` arguments."))
            end
        else
            isfinite(x) || return float(x)
            _round_sigdigits(x, r, sigdigits, base === nothing ? 10 : base)
        end
    else
        if sigdigits === nothing
            isfinite(x) || return float(x)
            _round_digits(x, r, digits, base === nothing ? 10 : base)
        else
            throw(ArgumentError("`round` cannot use both `digits` and `sigdigits` arguments."))
        end
    end
end
=#

function Base._round_sigdigits(x::FloatD64, r::RoundingMode, sigdigits::Integer, base)
    h = hidigit(x, base)
    _round_digits(x, r, sigdigits-h, base)
end

Base.hidigit(x::FloatD64, base) = hidigit(Hi(x), base)


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
