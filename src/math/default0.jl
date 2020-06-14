#=
const QuadMathFuncs = [:/, :*, :+, :-, :<, :<=, :(==), :^, 
    :abs, :acos, :acosh, :asin, :asinh, :atan, :atanh, :ceil, :copysign, :cos, :cosh, :exp, :expm1,
    :exponent, :flipsign, :floor, :frexp, :hypot, :isfinite, :isinf, :isinteger, :isnan, :ldexp,
    :log, :log10, :log1p, :log2, :modf, :nextfloat, :print, :reinterpret, :round, :show, :signbit,
    :significand, :sin, :sincos, :sinh, :sqrt, :string, :tan, :tanh, :trunc]
=#

for F in (:abs, :acos, :acosh, :asin, :asinh, :atan, :atanh, :cos, :cosh,
          :exp, :expm1, :log, :log10, :log1p, :log2, :sin, :sincos, :sinh,
          :sqrt, :tan, :tanh,
          :ceil, :floor, :trunc, :round,)
   @eval $F(x::Real} = FloatD64($F(Float128(x)))
end

Base.modf(x::Real) = FloatD64.(modf(Float128(x)))
Base.cbrt(x::Real) = FloatD64(Float128(x)^(Float128(1.0)/3))
Base.hypot(x::R, y::R) where {R<:Real} = FloatD64(hypot(Float128(x), Float128(y)))
