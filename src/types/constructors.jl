FloatD64(x::T) where {T<:Union{Float64, Float32, Float16, Int32, Int16, Int8}} =
    FloatD64((Float64(x), 0.0))

function FloatD64(x::T) where {T<:Union{Int64,Int128}}
    abs(x) > maxintfloat(Float64) && throw(InexactError(:FloatD64, Float64, x))
    return FloatD64((Float64(x), 0.0))
end

function FloatD64(x::T) where {T<:Union{BigFloat, Float128}}
    hi = Float64(x)
    lo = Float64(x - hi)
    return FloatD64((hi, lo))
end

FloatD64(x::T) where {T<:Union{BigInt, Int128}} =
    FloatD64(BigFloat(x))

FloatD64(x::Float64, y::Float64) = FloatD64(two_sum(x, y))
FloatD64(x, y) = FloatD64(Float64(x), Float64(y))

FloatD64(x::ComplexD64) = real(x)
FloatD64(x::ComplexF64) = FloatD64(real(x))

function ComplexD64(x::FloatD64)
    hi = ComplexF64(Hi(x))
    lo = ComplexF64(Lo(x))
    return ComplexD64((hi, lo))
end

ComplexD64(x::T) where {T<:Real} = ComplexD64(FloatD64(x))

ComplexD64(x::T1, y::T2) where {T1<:Real, T2<:Real} =
    ComplexD64( (ComplexF64(x), ComplexF64(y)) )

ComplexD64(x::Float64, y::Float64) = ComplexD64(( ComplexF64(x), ComplexF64(y) ))

# inverse constructors
Base.Float64(x::FloatD64) = Hi(x)
Base.Float64(x::ComplexD64) = real(Hi(x))
Base.ComplexF64(x::FloatD64) = ComplexF64(Hi(x), 0.0)
Base.ComplexF64(x::ComplexD64) = ComplexF64(Hi(x)...)
Base.BigFloat(x::FloatD64) = BigFloat(Hi(x)) + BigFloat(Lo(x))
Base.BigFloat(x::ComplexD64) = BigFloat(real(Hi(x))) + BigFloat(real(Lo(x)))

Quadmath.Float128(x::FloatD64) = Float128(Hi(x)) + Float128(Lo(x))
function FloatD64(x::Float128)
    hi = Float64(x)
    lo = Float64(x - hi)
    return Float64((hi, lo))
end
