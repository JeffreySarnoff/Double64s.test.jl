"""
    Double64s is a package

exported types: [`FloatD64`](@ref), [`ComplexD64`](@ref), [`FloatComplexD64`](@ref)

exported field accessors: [`hi`](@ref), [`lo`](@ref), [`hilo`](@ref)
"""
module Double64s

export FloatD64, ComplexD64, FloatComplexD64,
  hi, lo, hilo

using ErrorfreeArithmetic, Quadmath

# online help text for the types

"""
    FloatD64

A struct wrapping a Tuple of two Float64s: (most significant part, least significant part).

Also the constructor for that struct.
""" FloatD64

"""
    ComplexD64 <: Complex

A struct wrapping a Tuple of two Complex{Float64}s: (most significant part, least significant part).

Also the constructor for that struct.
""" ComplexD64

"""
    FloatComplexD64 <: Union

Union of FloatD64 and ComplexD64 types.
""" FloatComplexD64

"""
   hilo(x)

Unwraps the two tuple: (most significant part, least significant part).

see: [`hi`](@ref), [`lo`](@ref)
""" hilo

"""
   hi(x)

Unwraps the most significant part.

see: [`lo`](@ref), [`hilo`](@ref)
""" hi

"""
   lo(x)

Unwraps the least signficant part.

see: [`hi`](@ref), [`hilo`](@ref)
""" lo

include("types/double64.jl")
include("types/constructors.jl")

include("math/arith.jl")
include("math/default.jl")

end  # Double64s
