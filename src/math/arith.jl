# relative error < 3u², 20 FP Ops, 102.4 bits (relative)
# Algorithm 6 from [Joldes, Muller, Popescu 2017]
function Base.:(+)(x::FloatD64, y::FloatD64)
    hi, lo   = two_sum(Hi(x), Hi(y))
    thi, tlo = two_sum(Lo(x), Lo(y))
    c = lo + thi
    hi, lo = two_hilo_sum(hi, c)
    c = tlo + lo
    hi, lo = two_hilo_sum(hi, c)
    return FloatD64((hi, lo))
end

# relative error < 3u², 20 FP Ops, 102.4 bits (relative)
# Algorithm 6 from [Joldes, Muller, Popescu 2017]
# reworked for subtraction
function Base.:(-)(x::FloatD64, y::FloatD64)
    hi, lo   = two_diff(Hi(x), Hi(y))
    thi, tlo = two_diff(Lo(x), Lo(y))
    c = lo + thi
    hi, lo = two_hilo_sum(hi, c)
    c = tlo + lo
    hi, lo = two_hilo_sum(hi, c)
    return FloatD64((hi, lo))
end

# relative error < 5u², 9 FP Ops, 101.6 bits (relative)
# Algorithm 12 from [Joldes, Muller, Popescu 2017]
function Base.:(*)(x::FloatD64, y::FloatD64)
    hi, lo = two_prod(Hi(x), Hi(y))
    t = mul(Lo(x), Lo(y))
    t = fma(Hi(x), Lo(y), t)
    t = fma(Lo(x), Hi(y), t)
    t = lo + t
    hi, lo = two_hilo_sum(hi, t)
    return FloatD64((hi, lo))
end

# relative error < 9.8u², 31 FP Ops, 100.7 bits (relative)
# Algorithm 18 from [Joldes, Muller, Popescu 2017] 
function Base.:(/)(x::FloatD64, y::FloatD64)
    negihi = -inv(Hi(y))
    rhi = fma(Hi(y), negihi, 1.0) 
    rlo = mul(Lo(y), ihi)
    hi, lo = two_hilo_sum(rhi, rlo)
    hi = mul(hi, ihi)
    lo = mul(lo, ihi)
    hi = add(hi, ihi)
    lo = add(lo, ihi)
    hi = mul(x, hi)
    lo = mul(x, lo)
    return FloatD64((hi, lo))
end

# relative error < 9.8u², 31 FP Ops, 100.7 bits (relative)
# Algorithm 18 from [Joldes, Muller, Popescu 2017] 
function Base.:(inv)(y::FloatD64)
    negihi = -inv(Hi(y))
    rhi = fma(Hi(y), negihi, 1.0) 
    rlo = mul(Lo(y), ihi)
    hi, lo = two_hilo_sum(rhi, rlo)
    hi = mul(hi, ihi)
    lo = mul(lo, ihi)
    hi = add(hi, ihi)
    lo = add(lo, ihi)
    return FloatD64((hi, lo))
end

Base.:(\)(x::FloatD64, y::FloatD64) = (/)(y, x)
