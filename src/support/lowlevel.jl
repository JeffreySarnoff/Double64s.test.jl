function Base.modf(x::FloatD64)
    frc_hi, int_hi = modf(Hi(x))
    frc_lo, int_lo = modf(Lo(x))
    frc_part = FloatD64(two_hilo_sum(frc_hi, frc_lo))
    int_part = FloatD64(two_hilo_sum(int_hi, int_lo))
    return (frc_part, int_part)
end

fmod(parts::Tuple{FloatD64, FloatD64}) = fmod(parts...)
function fmod(frc_part::FloatD64, int_part::FloatD64)
    return int_part + frc_part
end

const log10of2 = log10(2)
const log2of10 = log2(10)

@inline digits2bits(x::Int) = floor(Int, log2of10*x)
@inline bits2digits(x::Int) = ceil(Int, log10of2*x)

# fractionalbits(x) is the smallest number of bits such that
# frac(x) = modf(x)[1]
# isinteger(frac(x) * 2.0^fractionalbits(frac(x)))
# fix for 0.0 and powers of 2 
function fractionalbits(x::Float64)
    fr = modf(x)[1]
    nbits = 53 - trailing_zeros((reinterpret(UInt64, fr) & 0x000f_ffff_ffff_ffff))
    return nbits
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
