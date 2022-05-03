Base.promote_rule(::Type{ComplexD64}, ::Type{Double64}) = ComplexD64
Base.convert(::Type{ComplexD64}, x::Double64) = ComplexD64(x)

for T in (:Float64, :Float32, :Float16, :Int128, :Int64, :Int32, :Int16, :Int8)
  @eval begin
    Base.promote_rule(::Type{Double64}, ::Type{$T}) = Double64
    Base.convert(::Type{Double64}, x::$T) = Double64(x)
    Base.convert(::Type{$T}, x::Double64) = $T(x)
  end
end

for T in (:BigFloat, :BigInt, :Float128)
  @eval begin
    Base.promote_rule(::Type{Double64}, ::Type{$T}) = $T
    Base.convert(::Type{Double64}, x::$T) = Double64(x)
    Base.convert(::Type{$T}, x::Double64) = $T(x)
  end   
end  

function Base.convert(::Type{Complex{BigFloat}}, x::ComplexD64)
   re, im = ReIm(x)
   return Complex{BigFloat}(BigFloat(re), BigFloat(im))
end

function Base.convert(::Type{Complex{Float128}}, x::ComplexD64)
   return Complex{Float128}(Float128(x.re), Float128(x.im))
end

function Base.convert(::Type{ComplexD64}, x::Complex{BigFloat})
    re = Double64(real(x))
    im = Double64(imag(x))
    return ComplexD64((re, im))
end

function Base.convert(::Type{ComplexD64}, x::Complex{Float128})
    re = Double64(real(x))
    im = Double64(imag(x))
    return ComplexD64((re, im))
end
