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

FloatD64(x::FloatD64) = x   # idempotent

# indirect initialization (two_sum returns a 2-Tuple)
FloatD64(x::Float64, y::Float64) = FloatD64(two_sum(x,y))

# initialization with a single value

FloatD64(x::Float64) = FloatD64(x, 0.0)

FloatD64(x::T) where {T<:Union{Float16, Float32}} = FloatD64(Float64(x))
FloatD64(x::T) where {T<:Union{Int8, Int16, Int32}} = FloatD64(Float64(x))

function FloatD64(x::T) where {T<:Union{Int64, Float128, Int128, BigInt, BigFloat}}
    hi = Float64(x)
    lo = Float64(x - hi)
    FloatD64((hi, lo))
end

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

const ZeroD64 = FloatD64((0.0, 0.0))
const HalfD64 = FloatD64((0.5, 0.0))
const OneD64 = FloatD64((1.0, 0.0))
const TwoD64 = FloatD64((2.0, 0.0))

const NaND64 = FloatD64((NaN, NaN))
const InfD64 = FloatD64((Inf, Inf))
const NegInfD64 = FloatD64((-Inf, -Inf))

Base.floatmin(::Type{FloatD64}) = FloatD64(floatmin(Float64))
Base.floatmax(::Type{FloatD64}) = FloatD64((floatmax(Float64), (floatmax(Float64) * (2^(-53)))))
Base.typemin(::Type{FloatD64})  = FloatD64(typemin(Float64))
Base.typemax(::Type{FloatD64})  = FloatD64(typemax(Float64))
Base.maxintfloat(::Type{FloatD64}) = FloatD64(maxintfloat(Float64))

