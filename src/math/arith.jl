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
    yhi, ylo = HiLo(y)
    th = inv(yhi)
    rh = fma(-yhi, th, 1.0)
    rl = -ylo * th
    eh, el = two_hilo_sum(rh, rl)
    dh, dl = DWTimesFP3(eh, el, th) # (eh, el) * rh
    mh, ml = DWPlusFP(dh, dl, th) # (dh, dl) + th
    zh, zl = DWTimesDW2(Hi(x), Lo(x), mh, ml) # (xh, xl) * (mh, ml)
    return FloatD64(zh, zl)
end

# algorithm 9 from [Joldes, Muller, Popescu 2017] 
@inline function DWTimesFP3(xh, xl, y)
    ch, cl1 = two_prod(xh, y)
    cl3 = fma(xl, y, cl1)
    zh, zl = two_hilo_sum(ch, cl3)
    return zh, zl
end
# algorithm 4 from [Joldes, Muller, Popescu 2017] 
@inline function DWPlusFP(xh::Float64, xl::Float64, y::Float64)
    sh, sl = two_sum(xh, y)
    v = xl + sl
    zh, zl = two_hilo_sum(sh, v)
    return zh, zl
end
# algorithm 12 from [Joldes, Muller, Popescu 2017] 
@inline function DWTimesDW2(xh, xl, yh, yl)
    ch, cl1 = two_prod(xh, yh)
    tl0 = xl * yl
    tl1 = fma(xh, yl, tl0)
    cl2 = fma(xl, yh, tl1)
    cl3 = cl1 + cl2
    zh, zl = two_hilo_sum(ch, cl3)
    return zh, zl
end

# relative error < 9.8u², 31 FP Ops, 100.7 bits (relative)
# Algorithm 18 from [Joldes, Muller, Popescu 2017] 
function Base.:(inv)(y::FloatD64)
    yhi, ylo = HiLo(y)
    th = inv(yhi)
    rh = fma(-yhi, th, 1.0)
    rl = -ylo * th
    eh, el = two_hilo_sum(rh, rl)
    dh, dl = DWTimesFP3(eh, el, th) # (eh, el) * rh
    mh, ml = DWPlusFP(dh, dl, th) # (dh, dl) + th
    # zh, zl = DWTimesDW2(1.0, 0.0, mh, ml) # (1, 0) * (mh, ml)
    return FloatD64(mh, ml)
end

Base.:(\)(x::FloatD64, y::FloatD64) = (/)(y, x)
