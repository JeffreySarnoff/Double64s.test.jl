FloatD64(x::T) where {T<:Union{Float64, Float32, Float16, Int32, Int16, Int8}} =
    FloatD64((Float64(x), 0.0))

function FloatD64(x::T) where {T<:Union{Int64,Int128,Float128}}
    if abs(x) <= maxintfloat(Float64)
        hi = Float64(x)
        lo = 0.0
    else
        bf = BigFloat(x)
        hi = Float64(x)
        lo = Float64(bf - hi)
    end
    return FloatD64((hi, lo))
end

function FloatD64(x::BigFloat)
    hi = Float64(x)
    lo = Float64(x - hi)
    return FloatD64((hi, lo))
end

function FloatD64(x::BigInt)
    if abs(x) <= typemax(Int128)
        FloatD64(Int128(x))
    else    
         FloatD64(BigFloat(x))
    end
end

FloatD64(x::Real, y::Real) = FloatD64(Float64(x), Float64(y))

FloatD64(x::ComplexD64) = real(x)
FloatD64(x::ComplexF64) = FloatD64(real(x))

ComplexD64(x::Float64) = ComplexD64(FloatD64(x))
ComplexD64(x::Float64, y::Float64) = ComplexD64( FloatD64(x), FloatD64(y) )
ComplexD64(x::ComplexF64) = ComplexD64(x.re, x.im)

# inverse constructors
Base.Float64(x::FloatD64) = Hi(x)
Base.Float64(x::ComplexD64) = real(Hi(x))
Base.ComplexF64(x::FloatD64) = ComplexF64(Hi(x), 0.0)
Base.ComplexF64(x::ComplexD64) = ComplexF64(Hi(x)...)
Base.BigFloat(x::FloatD64) = BigFloat(Hi(x)) + BigFloat(Lo(x))
Base.BigFloat(x::ComplexD64) = BigFloat(real(Hi(x))) + BigFloat(real(Lo(x)))
Base.BigInt(x::FloatD64) = BigInt(BigFloat(x))
Base.BigInt(x::ComplexD64) = BigInt(BigFloat(x))
Base.Int128(x::FloatD64) = Int128(BigInt(x))
Base.Int128(x::ComplexD64) = Int128(BigInt(x))

for T in (:Float32, :Float16, :Int32, :Int16, :Int8)
    @eval Base.$T(x::FloatD64) = $T(Hi(x))
end

Quadmath.Float128(x::FloatD64) = Float128(Hi(x)) + Float128(Lo(x))
