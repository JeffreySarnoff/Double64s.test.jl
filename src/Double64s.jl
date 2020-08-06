"""
    Double64s is a package

exported types: [`FloatD64`](@ref), [`ComplexD64`](@ref), [`FloatComplexD64`](@ref)

exported field accessors: [`Hi`](@ref), [`Lo`](@ref), [`HiLo`](@ref)
"""
module Double64s

export FloatD64, ComplexD64, FloatComplexD64,
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
include("types/comparison.jl")
include("types/promotion.jl")
include("types/predicates.jl")

include("math/prearith.jl")
include("math/arith.jl")
include("math/rounding.jl")
include("math/fma.jl")
include("math/roots.jl")

end  # Double64s
