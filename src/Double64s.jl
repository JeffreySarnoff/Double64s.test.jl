module Double64s

export FloatD64, ComplexD64,
  hi, lo, hilo

"""
    TwoTupleF64

Two Float64s as a Tuple.
""" TwoTupleF64

"""
    TwoTupleC64

Two Complex{Float64}s as a Tuple.
""" TwoTupleC64

"""
    TwoTuple64

Union{TwoTupleF64, TwoTupleC64}
""" TwoTuple64

"""
    FloatD64 <: Real

A struct wrapping `TwoTupleF64`
""" FloatD64

"""
    ComplexD64 <: Complex

A struct wrapping `TwoTupleC64`
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


end  # Double64s
