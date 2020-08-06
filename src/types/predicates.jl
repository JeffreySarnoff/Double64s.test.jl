for T in (:FloatD64, :ComplexD64)
  @eval begin
    Base.isnan(x::$T) = isnan(Hi(x))
    Base.isinf(x::$T) = isinf(Hi(x))
    Base.isfinite(x::$T) = isfinite(Hi(x))
    Base.iszero(x::$T) = iszero(Hi(x))
    Base.isone(x::$T) = isone(Hi(x)) && iszero(Lo(x))
    Base.isinteger(x::$T) = isinteger(Hi(x)) && isinteger(Lo(x))
  end
end

function Base.iseven(x::Float64)
    !isinteger(x) && return false
    absx = abs(x)
    if absx < typemax(Int64)
       iseven(Int64(x))
    elseif absx < typemax(Int128)
       iseven(Int128(x))
    else
       iseven(BigInt(x))
    end
end

function Base.isodd(x::Float64)
    !isinteger(x) && return false
    absx = abs(x)
    if absx < typemax(Int64)
       isodd(Int64(x))
    elseif absx < typemax(Int128)
       isodd(Int128(x))
    else
       isodd(BigInt(x))
    end
end
