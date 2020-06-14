for F in (:abs, :sqrt, :cbrt,
          :exp, :expm1, :log, :log10, :log1p, :log2,
          :acos, :acosh, :asin, :asinh, :atan, :atanh,
          :cos, :cosh, :sin, :sincos, :sinh, :tan, :tanh,
          :ceil, :floor, :trunc, :round,)
   @eval $F(x::Real) = FloatD64($F(Float128(x)))
end

Base.modf(x::Real) = FloatD64.(modf(Float128(x)))
Base.cbrt(x::Real) = FloatD64(Float128(x)^(Float128(1.0)/3))
Base.hypot(x::R, y::R) where {R<:Real} = FloatD64(hypot(Float128(x), Float128(y)))
