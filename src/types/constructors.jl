TwoTupleF64(x::Float64) = (x, 0.0)
TwoTupleF64(x::Float64, y::Float64) = (x, y)

TwoTupleF64(x::ComplexF64, y::Float64) = (real(x), y)
TwoTupleF64(x::Float64, y::ComplexF64) = (x, real(y))
TwoTuplef64(x::ComplexF64, y::ComplexF64) = (real(x), real(y))

TwoTupleC64(x::Float64) = (Complex{Float64}(x,0.0), Complex{Float64}(0.0,0.0))
TwoTupleC64(x::Float64, y::Float64) = (Complex{Float64}(x,0.0), Complex{Float64}(y,0.0))

TwoTupleC64(x::ComplexF64) = (x, Complex{Float64}(0.0,0.0))
TwoTupleC64(x::ComplexF64, y::ComplexF64) = (x, y)
TwoTupleC64(x::ComplexF64, y::Float64) = (x, Complex{Float64}(y,0.0))
TwoTupleC64(x::Float64, y::ComplexF64) = (Complex{Float64}(x,0.0), y)

FloatD64(x::Float64) = FloatD64((x, 0.0))
FloatD64(x::Float64, y::Float64) = FloatD64(two_sum(x, y))

ComplexD64(x::ComplexF64) = ComplexD64((x, 0.0+0.0im))
ComplexD64(x::ComplexF64, y::ComplexF64) = ComplexD64(two_sum(x, y))

function FloatD64(x::BigFloat)
    hi = Float64(x)
    lo = Float64(x - hi)
    return FloatD64((hi, lo))
end

function ComplexD64(x::Complex{BigFloat})
    hi = ComplexF64(x)
    lo = ComplexF64(x - hi)
    return ComplexD64((hi, lo))
end

FloatD64(x::T) where {T<:Union{BigInt, Int128}} = FloatD64(BigFloat(x))
ComplexD64(x::Complex{T}) where {T<:Union{BigInt, Int128}} = ComplexD64(Complex{BigFloat}(x))

function FloatD64(x::Int64)
    hi = maxintfloat(Float64)
    if abs(x) <= hi 
       FloatD64(Float64(x))
    else
       hi = copysign(hi, x)
       lo = x - hi
       FloatD64(Float64(hi), Float64(lo)) # does two_sum
    end
end

FloatD64(x::T) where {T<:Union{Int32, Int16, Int8}} = FloatD64(Int64(x))
FloatD64(x::T) where {T<:Union{Float16, Float32}} = FloatD64(Float64(x))
FloatD64(x::T) where {T<:Signed} = FloatD64(BigInt(x))
FloatD64(x::T) where {T<:Real} = FloatD64(BigFloat(x))

ComplexD64(x::Int64) = ComplexD64(FloatD64(x))
ComplexD64(x::T) where {T<:Union{Int32, Int16, Int8}} = ComplexD64(Int64(x))
ComplexD64(x::T) where {T<:Union{Float16, Float32}} = ComplexD64(Float64(x))
ComplexD64(x::T) where {T<:Signed} = ComplexD64(BigInt(x))
ComplexD64(x::T) where {T<:Real} = ComplexD64(BigFloat(x))
ComplexD64(x::T, y::T) where {T<:Real} = ComplexD64(FloatD64(x), FloatD64(y))

# inverse constructors
Base.Float64(x::FloatD64) = hi(x)
Base.Float64(x::ComplexD64) = real(hi(x))
Base.ComplexF64(x::FloatD64) = ComplexF64(hi(x), 0.0)
Base.ComplexF64(x::ComplexD64) = ComplexF64(hi(x)...)
Base.BigFloat(x::FloatD64) = BigFloat(hi(x)) + BigFloat(lo(x))
Base.BigFloat(x::ComplexD64) = BigFloat(real(hi(x))) + BigFloat(real(lo(x)))

Quadmath.Float128(x::FloatD64) = Float128(hi(x)) + Float128(lo(x))
function FloatD64(x::Float128)
    hi = Float64(x)
    lo = Float64(x - hi)
    return Float64((hi, lo))
end
