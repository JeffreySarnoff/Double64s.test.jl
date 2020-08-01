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
    t = Lo(x) * Lo(y)
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

function Base.:(+)(x::ComplexD64, y::ComplexD64)
    re = real(x) + real(y)
    im = imag(x) + imag(y)
    hi = ComplexF64(Hi(re), Hi(im))
    lo = ComplexF64(Lo(re), Lo(im))
    return ComplexD64((hi, lo))
end

function Base.:(-)(x::ComplexD64, y::ComplexD64)
    re = real(x) - real(y)
    im = imag(x) - imag(y)
    hi = ComplexF64(Hi(re), Hi(im))
    lo = ComplexF64(Lo(re), Lo(im))
    return ComplexD64((hi, lo))
end

function Base.:(*)(x::ComplexD64, y::ComplexD64)
    xr = real(x); xi = imag(x); yr = real(y); yi = imag(y)
    re = xr * yr - xi * yi
    im = xr * yi + xi * yr
    hi = ComplexF64(Hi(re), Hi(im))
    lo = ComplexF64(Lo(re), Lo(im))
    return ComplexD64((hi, lo))
end

#=
   This is adapted from
   "Improved Complex Division"
    by Michael Baudin (DIGITEO) and Robert Smith (Stanford University)
    Version 0.1. February 2011
=#
function Base.:(/)(x::ComplexD64, y::ComplexD64)
    a = real(x); b = imag(x); c = real(y); d = imag(y)
    if ( abs(d) <= abs(c) ) then
        r = d/c
        t = 1/fma(d, r, c)
        if (r == 0) then
            e = muladd( d, b/c, a) * t # (a + d * (b/c)) * t
            f = muladd(-d, a/c, b) * t # (b - d * (a/c)) * t
        else
            e = muladd( b, r, a) * t # (a + b * r) * t
            f = muladd(-a, r, b) * t # (b - a * r) * t
        end
    else
        r = c/d
        t = inv(muladd(c, r, d)) # 1/(c * r + d )
        if (r == 0) then
            e = muladd(c, a/d,  b) * t # (c * (a/d) + b) * t
            f = muladd(c, b/d, -a) * t # (c * (b/d) - a) * t
        else
            e = muladd(a, r,  b) * t # (a * r + b) * t
            f = muladd(b, r, -a) * t #(b * r - a) * t
        end
    end
    hi = ComplexF64(Hi(e), Hi(f)) 
    lo = ComplexF64(Lo(e), Lo(f))
    return ComplexD64((hi, lo))
end

function Base.:(/)(x::ComplexD64, y::ComplexD64)
    a = real(x); b = imag(x); c = real(y); d = imag(y)
    if ( abs(d) <= abs(c) ) then
        r = d/c
        t = 1/fma(d, r, c)
        if (r == 0) then
            d = d * t
            e = muladd( d, b/c, a) # (a + d * (b/c)) * t
            f = muladd(-d, a/c, b) # (b - d * (a/c)) * t
        else
            b = b * t
            a = a * t
            e = muladd( b, r, a) # (a + b * r) * t
            f = muladd(-a, r, b) # (b - a * r) * t
        end
    else
        r = c/d
        t = inv(muladd(c, r, d)) # 1/(c * r + d )
        if (r == 0) then
            e = muladd(c, a/d,  b) * t # (c * (a/d) + b) * t
            f = muladd(c, b/d, -a) * t # (c * (b/d) - a) * t
        else
            e = muladd(a, r,  b) * t # (a * r + b) * t
            f = muladd(b, r, -a) * t #(b * r - a) * t
        end
    end
    hi = ComplexF64(Hi(e), Hi(f)) 
    lo = ComplexF64(Lo(e), Lo(f))
    return ComplexD64((hi, lo))
end
