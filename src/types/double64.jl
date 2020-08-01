const HiLoF64 = Tuple{Float64, Float64}
const HiLoC64 = Tuple{Complex{Float64}, Complex{Float64}}
const HiLoFC64 = Union{HiLoF64, HiLoC64}

for T in (:HiLoF64, :HiLoC64)
  @eval begin
    hi(x::$T) = x[1]
    lo(x::$T) = x[2]
    hilo(x::$T) = x
  end
end

struct FloatD64 <: Real
    val::HiLoF64
end

struct ComplexD64 <: Number
    val::HiLoC64
end

const FloatComplexD64 = Union{FloatD64, ComplexD64}

for T in (:FloatD64, :ComplexD64)
  @eval begin
    hi(x::$T) = x.val[1]
    lo(x::$T) = x.val[2]
    hilo(x::$T) = x.val
  end
end

real(x::FloatD64) = x
imag(x::FloatD64) = FloatD64(0.0, 0.0)

real(x::ComplexD64) = FloatD64(real(hi(x)), real(lo(x)))
imag(x::ComplexD64) = FloatD64(imag(hi(x)), imag(lo(x)))

hireal(x::ComplexD64) = real(hi(x))
loreal(x::ComplexD64) = real(lo(x))
hiimag(x::ComplexD64) = imag(hi(x))
loimag(x::ComplexD64) = imag(lo(x))

hi(x::Float64) = x
lo(x::Float64) = 0.0
hilo(x::Float64) = (x, 0.0)

hi(x::Complex{Float64}) = x
lo(x::Complex{Float64}) = 0.0+0.0im
hilo(x::Complex{Float64}) = (x, 0.0+0.0im)
