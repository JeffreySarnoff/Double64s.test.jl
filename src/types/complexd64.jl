"""
    ComplexD64

A complex value formed or FloatD64 real and imaginary parts
Also a constructor for that.
""" 

struct ComplexD64 <: Number
    hilo::Tuple{Complex{Float64}, Complex{Float64}}
end

ComplexD64(x::ComplexD64) = x
ComplexD64(x::FloatD64) = ComplexD64((x, ZeroD64))
ComplexD64(x::Float64) = ComplexD64((FloatD64(x), ZeroD64)))
    
function ComplexD64(hi::Complex{Float64}, lo::Complex{Float64})
    rehi, relo = two_sum(real(hi), real(lo))
    imhi, imlo = two_sum(imag(hi), imag(lo))
    hi = ComplexF64(rehi, imhi)
    lo = ComplexF64(relo, imlo)
    ComplexD64((hi, lo))
end

function ComplexD64(real::FloatD64, imag::FloatD64)
    rehi, relo = HiLo(real)
    imhi, imlo = HiLo(imag)
     hi = ComplexF64(rehi, imhi)
    lo = ComplexF64(relo, imlo)
    ComplexD64((hi, lo))
end    
    
Hi(x::ComplexD64) = x.hilo[1]
Lo(x::ComplexD64) = x.hilo[2]
HiLo(x::ComplexD64) = x.hilo

Base.real(x::ComplexD64) = FloatD64(real(hi(x)), real(lo(x)))
Base.imag(x::ComplexD64) = FloatD64(imag(hi(x)), imag(lo(x)))

ComplexD64(real::FloatD64, imag::FloatD64) =
    ComplexD64(Complex{Float64}(Hi(real), Hi(imag)), Complex(Float64(Lo(real), Lo(imag)))
    
const CplxD64 = Complex{FloatD64}

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
