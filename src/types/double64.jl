struct FloatD64 <: AbstractFloat
    hi::Float64
    lo::Float64
end

Hi(x::FloatD64) = x.hi
Lo(x::FloatD64) = x.lo
HiLo(x::FloatD64) = (x.hi, x.lo)

FloatD64(x::Float64, y::Float64) = FloatD64(two_sum(x, y))

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

const ComplexD64 = Complex{FloatD64}

Hi(x::ComplexD64) = x.re
Lo(x::FloatD64) = x.val[2]
HiLo(x::FloatD64) = x.val

const FloatComplexD64 = Union{FloatD64, ComplexD64}

Base.real(x::FloatD64) = x
Base.imag(x::FloatD64) = FloatD64((0.0, 0.0))

Base.real(x::ComplexD64) = FloatD64((real(Hi(x)), real(Lo(x))))
Base.imag(x::ComplexD64) = FloatD64((imag(Hi(x)), imag(Lo(x))))

Hi(x::Float64) = x
Lo(x::Float64) = 0.0
HiLo(x::Float64) = (x, 0.0)
ReIm(x::Float64) = (x, 0.0)

Hi(x::ComplexF64) = x
Lo(x::ComplexF64) = 0.0+0.0im
HiLo(x::ComplexF64) = (x, 0.0+0.0im)
ReIm(x::ComplexF64) = (real(x), imag(x))

Hi(x::FloatD64) = x.val[1]
Lo(x::FloatD64) = x.val[2]
HiLo(x::FloatD64) = x.val
ReIm(x::FloatD64) = (x, zero(FloatD64))

Hi(x::ComplexD64) = x.val[1]
Lo(x::ComplexD64) = x.val[2]
HiLo(x::ComplexD64) = x.val
ReIm(x::ComplexD64) = (real(x), imag(x))
