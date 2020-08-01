#=
for F in (:sqrt, :cbrt,
          :exp, :expm1, :log, :log10, :log1p, :log2,
          :acos, :acosh, :asin, :asinh, :atan, :atanh,
          :cos, :cosh, :sin, :sincos, :sinh, :tan, :tanh,
          :round,)
   @eval Base.Math.$F(x::FloatD64) = FloatD64($F(Float128(x)))
end

Base.Math.modf(x::FloatD64) = FloatD64.(modf(Float128(x)))
Base.Math.hypot(x::FloatD64, y::FloatD64) = FloatD64(hypot(Float128(x), Float128(y)))

for F in (:sqrt, :cbrt,
          :exp, :expm1, :log, :log10, :log1p, :log2,
          :acos, :acosh, :asin, :asinh, :atan, :atanh,
          :cos, :cosh, :sin, :sincos, :sinh, :tan, :tanh,
          :round,)
   @eval Base.Math.$F(x::ComplexD64) = ComplexD64($F(Complex{Float128}(x)))
end

Base.Math.modf(x::ComplexD64) = ComplexD64.(modf(Complex{Float128}(x)))
Base.Math.hypot(x::ComplexD64, y::ComplexD64) = ComplexD64(hypot(Complex{Float128}(x), Complex{Float128}(y)))
=#
