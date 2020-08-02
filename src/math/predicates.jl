for T in (:FloatD64, :ComplexD64)
  @eval begin
    Base.isnan(x::$T) = isnan(Hi(x))
    Base.isinf(x::$T) = isinf(Hi(x))
    Base.isfinite(x::$T) = isfinite(Hi(x))
    Base.issubnormal(x::$T) = issubnormal(Hi(x))
    Base.iszero(x::$T) = iszero(Hi(x))
    Base.isone(x::$T) = isone(Hi(x)) && iszero(Lo(x))
    Base.isinteger(x::$T) = isinteger(Hi(x)) && isinteger(Lo(x))
  end
end

