module Double64s

export FloatD64, ComplexD64,
  hi, lo, hilo

using ErrorfreeArithmetic, Quadmath

"""
    TwoF64

Two Float64s as a Tuple.
""" TwoF64

"""
    TwoC64

Two Complex{Float64}s as a Tuple.
""" TwoC64

"""
    Two64

Union{TwoF64, TwoC64}
""" Two64

"""
    FloatD64 <: Real

A struct wrapping `TwoF64`
""" FloatD64

"""
    ComplexD64 <: Complex

A struct wrapping `TwoC64`
""" ComplexD64

"""
    FloatCmplxD64

Union{FloatD64, ComplexD64}
""" FloatCmplxD64

"""
   hilo(x)

unwraps x::FloatCmplxD64
""" hilo

"""
   hi(x)

unwraps first(x::FloatCmplxD64)
""" hi

"""
   lo(x)

unwraps last(x::FloatCmplxD64)
""" lo

include("types/double64.jl")
include("types/constructors.jl")

include("math/arith.jl")
include("math/default.jl")

end  # Double64s
