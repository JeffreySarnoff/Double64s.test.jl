"""
    Double64s is a package

exported types: [`Double64`](@ref), [`ComplexD64`](@ref)

exported field accessors: [`Hi`](@ref), [`Lo`](@ref), [`HiLo`](@ref)
"""
module Double64s

export Double64, ComplexD64,
  Hi, Lo, HiLo,
  NaND64, InfD64,
  signs, signbits,
  fastabs, fastabs2

using ErrorfreeArithmetic, Quadmath

# online help text for the types


"""
   fastabs(x)

abs(Hi(x))
""" fastabs

"""
   fastabs2(x)

abs2(Hi(x))
""" fastabs2

include("types/double64.jl")
include("types/constructors.jl")
include("support/fast_minmax.jl")
include("types/comparison.jl")
include("types/promotion.jl")
include("types/predicates.jl")

include("math/prearith.jl")
include("math/arith.jl")
include("math/rounding.jl")
include("math/fma.jl")
include("math/roots.jl")

for F in (:abs, :acos, :acosh, :asin, :asinh, :atan, :atanh, :ceil, :cos, :cosh,
          :exp, :exp2, :exp10, :expm1, :log, :log2, :log10, :log1p,
          :sin, :sinh, :sqrt)
    @eval Base.$F(x::Double64) = Double64($F(Float128(x)))
end

end  # Double64s
