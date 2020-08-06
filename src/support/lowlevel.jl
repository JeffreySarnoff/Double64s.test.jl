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

