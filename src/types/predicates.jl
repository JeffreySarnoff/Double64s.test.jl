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

Base.issubnormal(x::FloatD64) = issubnormal(Hi(x))

Base.floatmin(::Type{FloatD64}) = FloatD64(floatmin(Float64))
Base.floatmax(::Type{FloatD64}) = FloatD64(floatmax(Float64))
Base.typemin(::Type{FloatD64}) = FloatD64(typemin(Float64))
Base.typemax(::Type{FloatD64}) = FloatD64(typemax(Float64))

