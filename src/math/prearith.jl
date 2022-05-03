Base.signbit(x::Double64) = signbit(Hi(x))
signbits(x::Double64) = (signbit(Hi(x), signbit(Lo(x))))
Base.sign(x::Double64) = sign(Hi(x))
signs(x::Double64) = (sign(Hi(x), sign(Lo(x))))
Base.significand(x::Double64) = (significand(Hi(x)), significand(Lo(x)))
Base.exponent(x::Double64) = (exponent(Hi(x)), exponent(Lo(x)))

significant_bits(::Type{Float64})    =   53
significant_bits(::Type{Double64})   = 2*53
significant_bits(::Type{ComplexF64}) =   53
significant_bits(::Type{ComplexD64}) = 2*53

Base.frexp(x::Double64) = (frexp(Hi(x)), frexp(Lo(x)))

function Base.ldexp(x::Tuple{Tuple{Float64,Int64},Tuple{Float64,Int64}})    
    hi = ldexp(x[1]...)
    lo = ldexp(x[2]...)
    return Double64((hi, lo))
end

# like frexp, returns an integer-valued significand
function ntexp(x::Float64)
    fr, ex = frexp(x)
    nt = Int128(ldexp(fr, 53))
    ex -= 53
    return nt, ex
end

#=
    num, xp2, den = Base.decompose(x)
    if isone(den)
       BigFloat(x) == ldexp(BigFloat(num), xp2)
    else
       BigFloat(x) == ldexp(BigFloat(num), xp2) / den
    end
=#
function Base.decompose(x::Double64)
    hi = Hi(x)
    isnan(hi)  && return 0, 0, 0
    isinf(hi)  && return sign(x), 0, 0
    iszero(hi) && return 0, 0, sign(x)

    nt_hi, ex_hi = ntexp(Hi(x))
    nt_lo, ex_lo = ntexp(Lo(x))
    num = (nt_hi << abs(ex_hi-ex_lo)) + nt_lo
    xp2 = ex_lo
    return num, xp2, 1
end

Base.copysign(x::Double64, y) = signbit(y) ? -abs(x) : abs(x)
Base.flipsign(x::Double64, y) = signbit(y) ? -x : x

Base.:(-)(x::Double64) = Double64((-Hi(x), -Lo(x)))
Base.abs(x::Double64) = signbit(x) ? -x : x
Base.abs2(x::Double64) = x*x
fastabs(x::Double64) = abs(Hi(x))
fastabs2(x::Double64) = abs2(Hi(x))

Base.:(-)(x::ComplexD64) = ComplexD64((-Hi(x), -Lo(x)))
fastabs(x::ComplexD64) = abs(Hi(x))
fastabs2(x::ComplexD64) = abs2(Hi(x))

fastabs(x::Float64) = abs(x)
fastabs(x::ComplexF64) = abs(x)
fastabs2(x::Float64) = abs2(x)
fastabs2(x::ComplexF64) = abs2(x)

function Base.ceil(x::Double64)
    xhi = Hi(x)
    hi = ceil(Hi(x))
    if hi === xhi
        t = ceil(Lo(x))
        hi = hi + t
        lo = t - (hi - xhi)
    else
        lo = 0.0
    end
    return Double64((hi, lo))
end

Base.ceil(::Type{T}, x::Double64) where {T<:Integer} = T(ceil(x))

function Base.floor(x::Double64)
    xhi = Hi(x)
    hi = floor(Hi(x))
    if hi === xhi
        t = floor(Lo(x))
        hi = hi + t
        lo = t - (hi - xhi)
    else
        lo = 0.0
    end
    return Double64((hi, lo))
end

Base.floor(::Type{T}, x::Double64) where {T<:Integer} = T(floor(x))

function Base.trunc(x::Double64)
    return signbit(x) ? ceil(x) : floor(x)
end

Base.trunc(::Type{T}, x::Double64) where {T<:Integer} = T(trunc(x))

function Base.div(x::Double64, y::Double64)
    (!isfinite(x) || isnan(y)) && return NaND64
    !isfinite(y) && return zero(Double64)
    return trunc(x / y)
end

function Base.fld(x::Double64, y::Double64)
    (!isfinite(x) || isnan(y)) && return NaND64
    !isfinite(y) && return zero(Double64)
    return floor(x / y)
end

function Base.cld(x::Double64, y::Double64)
    (!isfinite(x) || isnan(y)) && return NaND64
    !isfinite(y) && return zero(Double64)
    return ceil(x / y)
end

function Base.rem(x::Double64, y::Double64)
    (!isfinite(x) || isnan(y)) && return NaND64
    !isfinite(y) && return x
    return x - div(x,y) * y
end

function Base.mod(x::Double64, y::Double64)
    (!isfinite(x) || isnan(y)) && return NaND64
    !isfinite(y) && return x
    return x - fld(x,y) * y
end

function Base.divrem(x::Double64, y::Double64)
    (!isfinite(x) || isnan(y)) && return NaND64
    !isfinite(y) && return zero(Double64)
    dv = trunc(x / y)
    rm = x - dv * y
    return dv, rm
end

function Base.fldmod(x::Double64, y::Double64)
    (!isfinite(x) || isnan(y)) && return NaND64
    !isfinite(y) && return zero(Double64)
    fr = floor(x / y)
    md = x - fr * y
    return fr, md
end

