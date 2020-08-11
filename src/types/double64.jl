#=
    What's going on here?

We need two ways of intializing our DoubledFloats:
- one that is immediate, when we know the hi, lo parts are given canonically
- one that is indirect, when we do not know that the hi, lo parts are canonical

There are more than three approaches, here are three:
(a) make the value part of the struct a 2-Tuple
  - use the constructor that takes a 2-Tuple as the immediate initializer
  - use the constructor that takes 2 Float64s as the indirect initializer
(b) use a singleton with inner constructors
   - the vanilla constructor uses indirect initialization
   - the constructor with the singleton arg uses direct initialization
(c) use two structs, one for internal purposes only
   - the internal struct is initialized immediately
   - the API struct is initialized indirectly
(d) use a parameterized struct
   - one parameter value signifies immediate initialization
   - another parameter value signifies indirect initialization


(d) gets messier than necessary (more difficult to maintain)

(c) requires a good deal of interconversion (so likely slower)

(b) works well, it is more verbose than (a)

(a) is implemented
=#

"""
    FloatD64

A struct wrapping a Tuple of two Float64s: (most significant part, least significant part).

Also a constructor for that struct.
""" FloatD64

struct FloatD64 <: AbstractFloat
    hilo::Tuple{Float64, Float64}
end

# indirect initialization (two_sum returns a 2-Tuple)
FloatD64(x::Float64, y::Float64) = FloatD64(two_sum(x,y))

# idempotency
FloatD64(x::FloatD64) = x

"""
   HiLo(x)

Unwraps the two tuple: (most significant part, least significant part).

see: [`Hi`](@ref), [`Lo`](@ref)
"""
HiLo(x::FloatD64) = x.hilo

"""
   Hi(x)

Unwraps the most significant part.

see: [`Lo`](@ref), [`HiLo`](@ref)
"""
Hi(x::FloatD64) = x.hilo[1]

"""
   Lo(x)

Unwraps the least signficant part.

see: [`Hi`](@ref), [`HiLo`](@ref)
"""
Lo(x::FloatD64) = x.hilo[2]

const NaND64 = FloatD64((NaN, NaN))
const InfD64 = FloatD64((Inf, Inf))
const NegInfD64 = FloatD64((-Inf, -Inf))

Base.floatmin(::Type{FloatD64}) = FloatD64(floatmin(Float64))
Base.floatmax(::Type{FloatD64}) = FloatD64(floatmax(Float64))
Base.typemin(::Type{FloatD64})  = FloatD64(typemin(Float64))
Base.typemax(::Type{FloatD64})  = FloatD64(typemax(Float64))
Base.maxintfloat(::Type{FloatD64}) = FloatD64(maxintfloat(Float64))

"""
    ComplexD64

A complex value formed or FloatD64 real and imaginary parts

Also a constructor for that.
""" 
const ComplexD64 = Complex{FloatD64}

Hi(x::ComplexD64) = ComplexF64(Hi(x.re), Hi(x.im))
Lo(x::ComplexD64) = ComplexF64(Lo(x.re), Lo(x.im))
HiLo(x::ComplexD64) = Hi(x), Lo(x)

"""
    FloatComplexD64 <: Union

Union of FloatD64 and ComplexD64 types.
"""
const FloatComplexD64 = Union{FloatD64, ComplexD64}

Base.real(x::FloatD64) = x
Base.imag(x::FloatD64) = FloatD64((0.0, 0.0))
