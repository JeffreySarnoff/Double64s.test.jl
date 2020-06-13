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
    FCD64

Union{FloatD64, ComplexD64}
""" FCD64

"""
   hilo(x)

unwraps x::D64
""" hilo

"""
   hi(x)

unwraps first(x::D64)
""" hi

"""
   lo(x)

unwraps last(x::D64)
""" lo


include("types/double64.jl")



hi(x::FloatD64) = x.val[1]
lo(x::FloatD64) = x.val[2]
hilo(x::FloatD64) = x.val

hi(x::ComplexD64) = x.val[1]
lo(x::ComplexD64) = x.val[2]
hilo(x::ComplexD64) = x.val

hi(x::Float64) = x
lo(x::Float64) = 0.0
hilo(x::Float64) = (x, 0.0)

hi(x::Complex{Float64}) = x
lo(x::Complex{Float64}) = 0.0+0.0im
hilo(x::Complex{Float64}) = (x, 0.0+0.0im)

end  # Double64s
