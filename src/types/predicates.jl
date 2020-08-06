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

for F in (:iseven, :isodd)
  for T in (:Float64, :FloatD64)
    @eval begin

      function Base.$F(x::$T)
          !isinteger(x) && return false
          absx = abs(x)
          if absx < typemax(Int64)
            $F(Int64(x))
          elseif absx < typemax(Int128)
             $F(Int128(x))
          else
             $F(BigInt(x))
          end
      end

    end
  end
end
