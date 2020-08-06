Base.signbit(x::FloatD64) = signbit(Hi(x))
signbits(x::FloatD64) = (signbit(Hi(x), signbit(Lo(x))))
Base.sign(x::FloatD64) = sign(Hi(x))
signs(x::FloatD64) = (sign(Hi(x), sign(Lo(x))))
Base.significand(x::FloatD64) = (significand(Hi(x)), significand(Lo(x)))
Base.exponent(x::FloatD64) = (exponent(Hi(x)), exponent(Lo(x)))

significant_bits(::Type{Float64})    =   53
significant_bits(::Type{FloatD64})   = 2*53
significant_bits(::Type{ComplexF64}) =   53
significant_bits(::Type{ComplexD64}) = 2*53

Base.frexp(x::FloatD64) = (frexp(Hi(x)), frexp(Lo(x)))
function Base.ldexp(x::Tuple{Tuple{Float64,Int64},Tuple{Float64,Int64}})
    hi = frexp(x[1]...)
    lo = frexp(x[2]...)
    return FloatD64((hi, lo))
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
function Base.decompose(x::FloatD64)
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

Base.copysign(x::FloatD64, y) = signbit(y) ? -abs(x) : abs(x)
Base.flipsign(x::FloatD64, y) = signbit(y) ? -x : x

Base.:(-)(x::FloatD64) = FloatD64((-Hi(x), -Lo(x)))
Base.abs(x::FloatD64) = signbit(x) ? -x : x
Base.abs2(x::FloatD64) = x*x
fastabs(x::FloatD64) = abs(Hi(x))
fastabs2(x::FloatD64) = abs2(Hi(x))

Base.:(-)(x::ComplexD64) = ComplexD64((-Hi(x), -Lo(x)))
fastabs(x::ComplexD64) = abs(Hi(x))
fastabs2(x::ComplexD64) = abs2(Hi(x))

fastabs(x::Float64) = abs(x)
fastabs(x::ComplexF64) = abs(x)
fastabs2(x::Float64) = abs2(x)
fastabs2(x::ComplexF64) = abs2(x)

function Base.ceil(x::FloatD64)
    xhi = Hi(x)
    hi = ceil(Hi(x))
    if hi === xhi
        t = ceil(Lo(x))
        hi = hi + t
        lo = t - (hi - xhi)
    else
        lo = 0.0
    end
    return FloatD64((hi, lo))
end

Base.ceil(::Type{T}, x::FloatD64) where {T<:Integer} = T(ceil(x))

function Base.floor(x::FloatD64)
    xhi = Hi(x)
    hi = floor(Hi(x))
    if hi === xhi
        t = floor(Lo(x))
        hi = hi + t
        lo = t - (hi - xhi)
    else
        lo = 0.0
    end
    return FloatD64((hi, lo))
end

Base.floor(::Type{T}, x::FloatD64) where {T<:Integer} = T(floor(x))

function Base.trunc(x::FloatD64)
    return signbit(x) ? ceil(x) : floor(x)
end

Base.trunc(::Type{T}, x::FloatD64) where {T<:Integer} = T(trunc(x))

function Base.div(x::FloatD64, y::FloatD64)
    (!isfinite(x) || isnan(y)) && return NaND64
    !isfinite(y) && return zero(FloatD64)
    return trunc(x / y)
end

function Base.fld(x::FloatD64, y::FloatD64)
    (!isfinite(x) || isnan(y)) && return NaND64
    !isfinite(y) && return zero(FloatD64)
    return floor(x / y)
end

function Base.cld(x::FloatD64, y::FloatD64)
    (!isfinite(x) || isnan(y)) && return NaND64
    !isfinite(y) && return zero(FloatD64)
    return ceil(x / y)
end

function Base.rem(x::FloatD64, y::FloatD64)
    (!isfinite(x) || isnan(y)) && return NaND64
    !isfinite(y) && return x
    return x - div(x,y) * y
end

function Base.mod(x::FloatD64, y::FloatD64)
    (!isfinite(x) || isnan(y)) && return NaND64
    !isfinite(y) && return x
    return x - fld(x,y) * y
end

function Base.divrem(x::FloatD64, y::FloatD64)
    (!isfinite(x) || isnan(y)) && return NaND64
    !isfinite(y) && return zero(FloatD64)
    dv = trunc(x / y)
    rm = x - dv * y
    return dv, rm
end

function Base.fldmod(x::FloatD64, y::FloatD64)
    (!isfinite(x) || isnan(y)) && return NaND64
    !isfinite(y) && return zero(FloatD64)
    fr = floor(x / y)
    md = x - fr * y
    return fr, md
end

function nearestint(x::T) where {T<:Union{Float64, FloatD64}}
    s, absx = signbit(x), abs(x)
    absx = absx + 0.5
    absx = trunc(absx)
    return s ? -absx : absx
end

function accurate_c1c2(value::Real, ::Type{T}, p=significant_bits(T)) where {T<:Real}
    r1 = one(typeof(value)) / value
    r = T(r1)
    ir = one(typeof(r)) / r
    irulp = T(4 * eps(ir))
    c1a = nearestint(inv(r * irulp))
    c1 = T(c1a * irulp)
    p2 = T(2.0)^(-p+4)
    scaledulp = T(p2 * eps(c1))
    c2a = nearestint( (value - c1) / scaledulp )
    c2 = T(c2a * scaledulp)
    return c1, c2
end

# ~2^(-105) q.v. Error bounds from extra-precise iterative refinement
# ACM Transactions on Mathematical Software Vol. 32, No. 2 pg 337
# .. IEEE-754 double precision as working precision (εw = 2−53) and double-double as residual precision (εr ≈ 2−105)."

Base.eps(::Type{FloatD64})   = 2.465190328815662e-32
Base.eps(x::FloatD64) = iszero(Lo(x)) ? Hi(x) * 2.465190328815662e-32 : eps(Lo(x))

#=
   faster 2.0^p
   for p in trunc(Int,log2(nextfloat(0.0))) .. trunc(Int, log2(prevfloat(floatmax(Float64), 354))
   for smaller p --> 0.0 for larger p --> Inf
=#
ldexp2pow(p::Float64) = ldexp(1.0, p)
#=
    ufp(x) is "unit in the first place"
    ufp(0) = 0
    ufp(x!=0) = 2.0^floor(log2(abs(x)))

    unsafe_ufp(x) errors on x in (NaN, Inf)
=#
@inline unsafe_ufp(x::Float64) = !iszero(x) ? ldexp(1.0, exponent(x)) : x
unsafe_ufp(x::FloatD64) = unsafe_ufp(Hi(x))

ufp(x::Float64) = isfinite(x) ? unsafe_ufp(x) : x
ufp(x::FloatD64) = ufp(Hi(x))

        
