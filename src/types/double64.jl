struct FloatD64 <: Real
    val::Tuple{Float64, Float64}
end

struct ComplexD64 <: Number
    val::Tuple{Complex{Float64}, Complex{Float64}}
end

const FloatComplexD64 = Union{FloatD64, ComplexD64}

for T in (:FloatD64, :ComplexD64)
  @eval begin
    Hi(x::$T) = x.val[1]
    Lo(x::$T) = x.val[2]
    HiLo(x::$T) = x.val
  end
end

real(x::FloatD64) = x
imag(x::FloatD64) = FloatD64((0.0, 0.0))

real(x::ComplexD64) = FloatD64((real(hi(x)), real(lo(x))))
imag(x::ComplexD64) = FloatD64((imag(hi(x)), imag(lo(x))))

Hi(x::Float64) = x
Lo(x::Float64) = 0.0
HiLo(x::Float64) = (x, 0.0)

Hi(x::Complex{Float64}) = x
Lo(x::Complex{Float64}) = 0.0+0.0im
HiLo(x::Complex{Float64}) = (x, 0.0+0.0im)
