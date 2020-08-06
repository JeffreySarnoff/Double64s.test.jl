#=
    What's going on here?

We need two ways of intializing our DoubledFloats:
- one that is immediate, when we know the hi, lo parts are given canonically
- one that is indirect, when we do not know that the hi, lo parts are canonical

There are more than three approaches, here are three:
(a) make the value part of the struct a 2-Tuple
  - use the constructor that takes a 2-Tuple as the immediate initializer
  - use the constructor that takes 2 Float64s as the indirect initializer
(b) use two structs, one for internal purposes only
   - the internal struct is initialized immediately
   - the API struct is initialized indirectly
(c) use a parameterized struct
   - one parameter value signifies immediate initialization
   - another parameter value signifies indirect initialization

(c) gets messier than necessary (more difficult to maintain)

(b) requires a good deal of interconversion (so likely slower)

(a) is implemented
=@

struct FloatD64 <: AbstractFloat
    hilo::Tuple{Float64, Float64}
end

Hi(x::FloatD64) = x.hilo[1]
Lo(x::FloatD64) = x.hilo[2]
HiLo(x::FloatD64) = x.hilo

FloatD64(x::Float64, y::Float64) = FloatD64(two_sum(x,y))

const ComplexD64 = Complex{FloatD64}

Hi(x::ComplexD64) = ComplexF64(Hi(x.re), Hi(x.im))
Lo(x::ComplexD64) = ComplexF64(Lo(x.re), Lo(x.im))
HiLo(x::ComplexD64) = Hi(x), Lo(x)

const FloatComplexD64 = Union{FloatD64, ComplexD64}

Base.real(x::FloatD64) = x
Base.imag(x::FloatD64) = FloatD64((0.0, 0.0))

#=
Base.:(-)(x::FloatD64) = FloatD64((-Hi(y), -Lo(y)))
Base.:(-)(x::FloatD64, y::FloatD64) = FloatD64(Hi(x)-Hi(y), Lo(x)-Lo(y))
Base.:(+)(x::FloatD64, y::FloatD64) = FloatD64(Hi(x)+Hi(y), Lo(x)+Lo(y))

Base.promote_rule(::Type{FloatD64}, ::Type{Float64}) = FloatD64
Base.promote_rule(::Type{FloatD64}, ::Type{Int64}) = FloatD64

Base.convert(::Type{FloatD64}, x::Float64) = FloatD64((x, 0.0))
Base.convert(::Type{FloatD64}, x::Int64) = FloatD64((Float64(x), 0.0))

Base.:(==)(x::FloatD64, y::FloatD64) = Hi(x) === Hi(y) && Lo(x) === Lo(y)
Base.:(<)(x::FloatD64, y::FloatD64) = Hi(x) < Hi(y) || (Lo(x) < Lo(y) && Hi(x) === Hi(y))
Base.:(<=)(x::FloatD64, y::FloatD64) = Hi(x) < Hi(y) || (Lo(x) <= Lo(y) && Hi(x) === Hi(y))
=#
