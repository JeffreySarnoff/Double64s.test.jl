"""
    Double64s is a package

exported types: [`FloatD64`](@ref), [`ComplexD64`](@ref), [`FloatComplexD64`](@ref)

exported field accessors: [`Hi`](@ref), [`Lo`](@ref), [`HiLo`](@ref)
"""
module Double64s

export FloatD64, ComplexD64, FloatComplexD64,
  Hi, Lo, HiLo,
  signs, signbits

using ErrorfreeArithmetic, Quadmath

# online help text for the types

"""
    FloatD64

A struct wrapping a Tuple of two Float64s: (most significant part, least significant part).

Also the constructor for that struct.
""" FloatD64

"""
    ComplexD64

A struct wrapping a Tuple of two Complex{Float64}s: (most significant part, least significant part).

Also the constructor for that struct.
""" ComplexD64

"""
    FloatComplexD64 <: Union

Union of FloatD64 and ComplexD64 types.
""" FloatComplexD64

"""
   HiLo(x)

Unwraps the two tuple: (most significant part, least significant part).

see: [`Hi`](@ref), [`Lo`](@ref)
""" HiLo

"""
   Hi(x)

Unwraps the most significant part.

see: [`Lo`](@ref), [`HiLo`](@ref)
""" Hi

"""
   Lo(x)

Unwraps the least signficant part.

see: [`Hi`](@ref), [`HiLo`](@ref)
""" Lo

include("types/double64.jl")
include("types/constructors.jl")

include("math/prearith.jl")
include("math/arith.jl")
include("math/default.jl")

end  # Double64s
