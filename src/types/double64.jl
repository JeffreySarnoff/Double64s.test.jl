struct FloatD64 <: Real
    val::Tuple{Float64, Float64}
end

struct ComplexD64 <: Number
    val::Tuple{Complex{Float64}, Complex{Float64}}
end

const FloatComplexD64 = Union{FloatD64, ComplexD64}

Hi(x::Float64) = x
Lo(x::Float64) = 0.0
HiLo(x::Float64) = (x, 0.0)

Hi(x::Complex{Float64}) = x
Lo(x::Complex{Float64}) = 0.0+0.0im
HiLo(x::Complex{Float64}) = (x, 0.0+0.0im)

Hi(x::FloatD64) = x.val[1]
Lo(x::FloatD64) = x.val[2]
HiLo(x::FloatD64) = x.val

Hi(x::ComplexD64) = x.val[1]
Lo(x::ComplexD64) = x.val[2]
HiLo(x::ComplexD64) = x.val

Base.real(x::FloatD64) = x
Base.imag(x::FloatD64) = FloatD64((0.0, 0.0))

Base.real(x::ComplexD64) = FloatD64((real(Hi(x)), real(Lo(x))))
Base.imag(x::ComplexD64) = FloatD64((imag(Hi(x)), imag(Lo(x))))
