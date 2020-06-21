"""
    Double64s

types: see @Ref[FloatD64], @Ref[ComplexD64], @Ref[FloatComplexD64]

type accessors: see @Ref[hi], @Ref[lo], @Ref[hilo]
"""
module Double64s

export FloatD64, ComplexD64,
  hi, lo, hilo

using ErrorfreeArithmetic, Quadmath

# online help text for the types

"""
    FloatD64 <: Real

A struct wrapping a Tuple of two Float64s: (most significant part, least significant part).
""" FloatD64

"""
    ComplexD64 <: Complex

A struct wrapping a Tuple of two Complex{Float64}s: (most significant part, least significant part).
""" ComplexD64

"""
    FloatComplexD64 <: Union

Union of FloatD64 and ComplexD64 types.
""" FloatComplexD64

"""
   hilo(x)

Unwraps x::Union{FloatD64, ComplexD64}, a two tuple: (most significant part, least significant part).
""" hilo

"""
   hi(x)

Unwraps first(x::FloatComplexD64), the most significant part.
""" hi

"""
   lo(x)

Unwraps last(x::FloatComplexD64), the least signficant part.
""" lo

include("types/double64.jl")
include("types/constructors.jl")

include("math/arith.jl")
include("math/default.jl")

end  # Double64s
