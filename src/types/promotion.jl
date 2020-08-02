Base.promote_rule(::Type{ComplexD64}, ::Type{FloatD64}) = ComplexD64
Base.convert(::Type{ComplexD64}, x::FloatD64) = ComplexD64(x)

for T in (:Float64, :Float32, :Float16, :Int128, :Int64, :Int32, :Int16, :Int8)
  @eval begin
    Base.promote_rule(::Type{FloatD64}, ::Type{$T}) = FloatD64
    Base.convert(::Type{FloatD64}, x::$T) = FloatD64(x)
  end
end

function Base.convert(::Type{BigFloat}, x::FloatD64)
   hi, lo = HiLo(x)
   return BigFloat(hi) + BigFloat(lo)
end

function Base.convert(::Type{Complex{BigFloat}}, x::ComplexD64)
   re, im = ReIm(x)
   return Complex{BigFloat}(BigFloat(re), BigFloat(im))
end

function Base.convert(::Type{Float128}, x::FloatD64)
   hi, lo = HiLo(x)
   return Float128(hi) + Float128(lo)
end

function Base.convert(::Type{Complex{Float128}}, x::ComplexD64)
   re, im = ReIm(x)
   return Complex{Float128}(Float128(re), Float128(im))
end

function Base.convert(::Type{FloatD64}, x::BigFloat)
    hi = Float64(x)
    lo = Float64(x - hi)
    return FloatD64((hi, lo))
end

function Base.convert(::Type{FloatD64}, x::Float128)
    hi = Float64(x)
    lo = Float64(x - hi)
    return FloatD64((hi, lo))
end

function Base.convert(::Type{ComplexD64}, x::Complex{BigFloat})
    re = FloatD64(real(x))
    im = FloatD64(imag(x))
    return ComplexD64((re, im))
end

function Base.convert(::Type{ComplexD64}, x::Complex{Float128})
    re = FloatD64(real(x))
    im = FloatD64(imag(x))
    return ComplexD64((re, im))
end

