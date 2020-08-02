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


ComplexD64(x::Float64) = ComplexD64((ComplexF64(x), zero(ComplexF64)))
ComplexD64(x::Float64, y::Float64) = ComplexD64((ComplexF64(x), ComplexF64(y)))

ComplexD64(x::FloatD64) = ComplexD64((x, 0.0))
ComplexD64(re::FloatD64, im::FloatD64) = ComplexD64((ComplexF64(Hi(re), Hi(im)), ComplexF64(Lo(re), Lo(im))))

ComplexD64(x::ComplexF64) = ComplexD64((x, 0.0+0.0im))
ComplexD64(x::ComplexF64, y::ComplexF64) = ComplexD64(two_sum(x, y))

FloatD64(x::BigInt) = FloatD64(BigFloat(x))
function FloatD64(x::BigFloat)
   if abs(x) <= maxintfloat(Float64)
        hi = Float64(x)
        lo = Float64(x-hi)
        FloatD64((hi, lo))
    else
        throw(InexactError(:FloatD64, Float64, x))
    end
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
