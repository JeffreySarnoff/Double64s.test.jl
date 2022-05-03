Double64(x::Float64) = Double64((x, 0.0))

for T in (:Float32, :Float16, :Int32, :Int16, :Int8)
    @eval Double64(x::$T) = ((Float64(x), 0.0))
end    

for T in (:Int64, :Int128)
  @eval function Double64(x::$T)
    if abs(x) <= maxintfloat(Float64)
        hi = Float64(x)
        lo = 0.0
    else
        bf = Float128(x)
        hi = Float64(x)
        lo = Float64(bf - hi)
    end
    return Double64((hi, lo))
  end      
end

function Double64(x::BigFloat)
    hi = Float64(x)
    lo = Float64(x - hi)
    return Double64((hi, lo))
end

function Double64(x::Float128)
    hi = Float64(x)
    lo = Float64(x - hi)
    return Double64((hi, lo))
end

function Double64(x::BigInt)
    if abs(x) <= typemax(Int128)
        Double64(Int128(x))
    else    
         Double64(BigFloat(x))
    end
end

Double64(x::Real, y::Real) = Double64(Float64(x), Float64(y))

Double64(x::ComplexD64) = real(x)
Double64(x::ComplexF64) = Double64(real(x))

ComplexD64(x::Float64) = ComplexD64(Double64(x))
ComplexD64(x::Float64, y::Float64) = ComplexD64( Double64(x), Double64(y) )
ComplexD64(x::ComplexF64) = ComplexD64(x.re, x.im)

# inverse constructors
Base.Float64(x::Double64) = Hi(x)
Base.Float64(x::ComplexD64) = real(Hi(x))
Base.ComplexF64(x::Double64) = ComplexF64(Hi(x), 0.0)
Base.ComplexF64(x::ComplexD64) = ComplexF64(Hi(x)...)
Base.BigFloat(x::Double64) = BigFloat(Hi(x)) + BigFloat(Lo(x))
Base.BigFloat(x::ComplexD64) = BigFloat(real(Hi(x))) + BigFloat(real(Lo(x)))
Base.BigInt(x::Double64) = BigInt(BigFloat(x))
Base.BigInt(x::ComplexD64) = BigInt(BigFloat(x))
Base.Int128(x::Double64) = Int128(BigInt(x))
Base.Int128(x::ComplexD64) = Int128(BigInt(x))

function Base.Int64(x::Double64)
    Int64(Hi(x)) + Int64(Lo(x))
end

for T in (:Float32, :Float16, :Int32, :Int16, :Int8)
    @eval Base.$T(x::Double64) = $T(Hi(x))
end

Float128(x::Double64) = Float128(Hi(x)) + Float128(Lo(x))
Double64(x::Float128) = Double64((Float64(x), Float64(x-Float64(x))))
ComplexD64(x::ComplexF128) = (Double64(real(x)), Double64(imag(x)))
ComplexF128(x::ComplexD64) = ComplexF128(real(x), imag(x))
