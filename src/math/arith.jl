# Algorithm 6 from [Joldes, Muller, Popescu 2017]
# relative error < 3u², 20 FP Ops
# rel accuracy [102.4, 104.4] bits
# "The largest relative error we have obtain through many tests is around 2.25 × 2^−2p = 2.25 u^2.
#  For Float64, this is 2.25*2^(-106) [rel accuracy 104.8 bits]." pg 11
function Base.:(+)(x::FloatD64, y::FloatD64) 
    hi, lo   = two_sum(Hi(x), Hi(y))
    thi, tlo = two_sum(Lo(x), Lo(y))
    c = lo + thi
    hi, lo = two_hilo_sum(hi, c)
    c = tlo + lo
    hi, lo = two_hilo_sum(hi, c)
    return FloatD64((hi, lo))
end

biterror(::typeof(+)) = 2.25

function Base.:(+)(x::FloatD64, y::Float64) 
    hi, lo = two_sum(Hi(x), y)
    c = lo + Lo(x)
    hi, lo = two_hilo_sum(hi, c)
    return FloatD64((hi, lo))
end

function Base.:(+)(x::Float64, y::FloatD64) 
    hi, lo = two_sum(x, Hi(y))
    c = lo + Lo(y)
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

biterror(::typeof(-)) = 2.25

function Base.:(-)(x::FloatD64, y::Float64) 
    hi, lo = two_diff(Hi(x), y)
    c = lo + Lo(x)
    hi, lo = two_hilo_sum(hi, c)
    return FloatD64((hi, lo))
end

function Base.:(-)(x::Float64, y::FloatD64) 
    hi, lo = two_diff(x, Hi(y))
    c = lo + Lo(y)
    hi, lo = two_hilo_sum(hi, c)
    return FloatD64((hi, lo))
end

# relative error < 5u², 9 FP Ops, 101.6 bits (relative)
# "The largest relative error we have obtain through many tests is 3.936 × 2^−2p = 3.936 * 2^(-106).
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

biterror(::typeof(*)) = 3.936


function Base.:(*)(x::FloatD64, y::Float64)
    hi, lo = two_prod(Hi(x), y)
    t = Lo(x) * y   
    t = t + lo
    hi, lo = two_hilo_sum(hi, t)
    return FloatD64((hi, lo))
end

function Base.:(*)(x::Float64, y::FloatD64)
    hi, lo = two_prod(x, Hi(y))
    t = x * Lo(y)
    t = lo + t
    hi, lo = two_hilo_sum(hi, t)
    return FloatD64((hi, lo))
end

    
# from DoubleFloats
# Base.:(/)(x::FloatD64, y::FloatD64) = FloatD64(divide_dddd_dd(Hi(x), Lo(x), Hi(y), Lo(y)))
(div0)(x::FloatD64, y::FloatD64) = FloatD64(divide_dddd_dd(Hi(x), Lo(x), Hi(y), Lo(y)))

@inline function divide_dddd_dd(xhi::T, xlo::T, yhi::T, ylo::T) where {T<:Float64}
    hi = xhi / yhi
    uh, ul = two_prod(hi, yhi)
    lo = ((((xhi - uh) - ul) + xlo) - hi*ylo)/yhi
    hi,lo = two_hilo_sum(hi, lo)
    return hi, lo
end

# Algorithm 17 from [Joldes, Muller, Popescu 2017]
# relative error <= 15u² + 56u³
function div17(x::FloatD64, y::FloatD64)
    xhi, xlo = HiLo(x)
    yhi, ylo = HiLo(y)
    thi = xhi / yhi
    rhi, rlo = DWTimesFP3(yhi, ylo, thi)
    dhi = xhi - rhi
    dlo = xlo - rlo
    d = dhi + dlo
    tlo = d / yhi
    return FloatD64(two_hilo_sum(thi, tlo))
end


function (div18)(x::FloatD64, y::FloatD64)
    yhi, ylo = HiLo(y)
    th = inv(yhi)
    rh = fma(-yhi, th, 1.0)
    rl = -ylo * th
    eh, el = two_hilo_sum(rh, rl)
    dh, dl = DWTimesFP3(eh, el, th) # (eh, el) * rh
    mh, ml = DWPlusFP(dh, dl, th) # (dh, dl) + th
    zh, zl = DWTimesDW2(Hi(x), Lo(x), mh, ml) # (xh, xl) * (mh, ml)
    return FloatD64((zh, zl))
end


# relative error < 9.8u², 31 FP Ops, 100.7 bits (relative)
# " 5.922 x 2^(-106) "
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
    return FloatD64((zh, zl))
end



    biterror(::typeof(/)) = 5.922
biterror(::typeof(inv)) = 5.922

function Base.:(/)(x::FloatD64, y::Float64)
    th = inv(y)
    rh = fma(-y, th, 1.0)
    dh, dl = DWTimesFP3(rh, 0.0, th) # (eh, el) * rh
    mh, ml = DWPlusFP(dh, dl, th) # (dh, dl) + th
    zh, zl = DWTimesDW2(Hi(x), Lo(x), mh, ml) # (xh, xl) * (mh, ml)
    return FloatD64((zh, zl))
end

function Base.:(/)(x::Float64, y::FloatD64)
    yhi, ylo = HiLo(y)
    th = inv(yhi)
    rh = fma(-yhi, th, 1.0)
    rl = -ylo * th
    eh, el = two_hilo_sum(rh, rl)
    dh, dl = DWTimesFP3(eh, el, th) # (eh, el) * rh
    mh, ml = DWPlusFP(dh, dl, th) # (dh, dl) + th
    zh, zl = DWTimesDW2(x, 0.0, mh, ml) # (xh, xl) * (mh, ml)
    return FloatD64((zh, zl))
end

# algorithm 4 from [Joldes, Muller, Popescu 2017] 
@inline function DWPlusFP(xh::Float64, xl::Float64, y::Float64)
    sh, sl = two_sum(xh, y)
    v = xl + sl
    zh, zl = two_hilo_sum(sh, v)
    return zh, zl
end
# algorithm 7 from [Joldes, Muller, Popescu 2017]
# calculation of (xh, xl) * y
@inline function DWTimesFP1(xh, xl, y)
    ch, cl1 = two_prod(xh, y)
    cl2 = xl*y
    th, tl1 = two_hilo_sum(ch, cl2)
    tl2 = tl1 + cl1
    zh, zl = two_hilo_sum(th, tl2)
    return zh, zl
end
# algorithm 9 from [Joldes, Muller, Popescu 2017] 
# calculation of (xh, xl) * y
@inline function DWTimesFP3(xh, xl, y)
    ch, cl1 = two_prod(xh, y)
    cl3 = fma(xl, y, cl1)
    zh, zl = two_hilo_sum(ch, cl3)
    return zh, zl
end

# algorithm 10 from [Joldes, Muller, Popescu 2017]
# calcualtes (xh, xl) * (yh, yl)
# the largest relative error found is  4.9916 × 2^(-106)
@inline function DWTimesDW1(xh, xl, yh, yl)
    ch, cl1 = two_prod(xh, yh)
    tl1 = xh * yl
    tl2 = xl * yh
    cl2 = tl1 + tl2
    cl3 = cl1 + cl2
    zh, zl = two_hilo_sum(ch, cl3)
    return zh, zl
end

# algorithm 12 from [Joldes, Muller, Popescu 2017]
# calcualtes (xh, xl) * (yh, yl)
# the largest relative error found is  3.936 × 2^(-106)
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
    return FloatD64((mh, ml))
end

Base.:(\)(x::FloatD64, y::FloatD64) = (/)(y, x)
Base.:(\)(x::FloatD64, y::Float64) = (/)(y, x)
Base.:(\)(x::Float64, y::FloatD64) = (/)(y, x)

for (T1, T2) in ((:ComplexD64, :ComplexD64), (:ComplexD64, :ComplexF64), (:ComplexF64, :ComplexD64))
  @eval begin
        
    function Base.:(+)(x::$T1, y::$T2)
        re = real(x) + real(y)
        im = imag(x) + imag(y)
        hi = ComplexF64(Hi(re), Hi(im))
        lo = ComplexF64(Lo(re), Lo(im))
        return ComplexD64((hi, lo))
    end

    function Base.:(-)(x::$T1, y::$T2)
        re = real(x) - real(y)
        im = imag(x) - imag(y)
        hi = ComplexF64(Hi(re), Hi(im))
        lo = ComplexF64(Lo(re), Lo(im))
        return ComplexD64((hi, lo))
    end

    function Base.:(*)(x::$T1, y::$T2)
        xr = real(x); xi = imag(x); yr = real(y); yi = imag(y)
        re = xr * yr - xi * yi
        im = xr * yi + xi * yr
        hi = ComplexF64(Hi(re), Hi(im))
        lo = ComplexF64(Lo(re), Lo(im))
        return ComplexD64((hi, lo))
    end
  end
end

#=
   This is adapted from
   "Improved Complex Division"
    by Michael Baudin (DIGITEO) and Robert Smith (Stanford University)
    Version 0.1. February 2011
    
    "A Robust Complex Division in Scilab
    by Michael Baudin, Robert L. Smith
    2012
=#

function Base.:(/)(x::ComplexD64, y::ComplexD64)
    a = real(x); b = imag(x); c = real(y); d = imag(y)
    if abs(d) <= abs(c)
        r = d/c
        t = inv(fma(d, r, c))
        if r == 0
            d = d * t
            e = fma( d, b/c, a) # (a + d * (b/c)) * t
            f = fma(-d, a/c, b) # (b - d * (a/c)) * t
        else
            b = b * t
            a = a * t
            e = fma( b, r, a) # (a + b * r) * t
            f = fma(-a, r, b) # (b - a * r) * t
        end
    else
        r = c/d
        t = inv(fma(c, r, d)) # 1/(c * r + d )
        if r == 0
            e = fma(c, a/d,  b) * t # (c * (a/d) + b) * t
            f = fma(c, b/d, -a) * t # (c * (b/d) - a) * t
        else
            e = fma(a, r,  b) * t # (a * r + b) * t
            f = fma(b, r, -a) * t #(b * r - a) * t
        end
    end
    hi = ComplexF64(Hi(e), Hi(f)) 
    lo = ComplexF64(Lo(e), Lo(f))
    return ComplexD64((hi, lo))
end


function divide(x::ComplexD64, y::ComplexD64)
    a = real(x); b = imag(x); c = real(y); d = imag(y)
    if abs(d) <= abs(c)
        r = d/c
        t = inv(muladd(d, r, c))
        if r == 0
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
        if r == 0
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


#=
adapted from 
On complex multiplication and division with an FMA
Jean-Michel Muller, C.-P. Jeannerod, P. Kornerup and N. Louvet
INVA 2014

function mul(ab::ComplexD64, cd::ComplexD64)
    re = Kahan(real(ab), real(cd), -imag(ab), imag(cd))
    im = Kahan(real(ab), imag(cd), imag(ab), real(cd))
    return ComplexD64((ComplexF64(Hi(re), Hi(im)), ComplexF64(Lo(re), Lo(im))))
end

function divide(ab::ComplexD64, cd::ComplexD64)
    a = real(ab); b = imag(ab); c = real(cd); d = imag(cd)
    delta = c*c + d*d
    gre = Kahan(a, b,c,d) # ac + bd
    gim = Kahan(b,-a,c,d) # bc - ad
    qre = gre / delta
    qim = gim / delta
    return qre, qim
end

function Kahan(a, b, c, d)
    w = c * d
    e = fma(c, d, -w)
    f = fma(a, b, w)
    r = f + e
    return r
end

Base.fma(x::FloatD64,y::FloatD64,z::FloatD64) = muladd(x,y,z)
=#
#=

function normalizedenom(n,d)
    fr,xp = frexp(d)
    n = ldexp(n, -xp)
    return n, fr
end

function normalized(n::FloatD64, d::FloatD64)
    scaleby = inv(Hi(d))
    return n*scaleby, d*scaleby
end

function Goldschmidt(n::T,d::T,k) where {T}
    n, d = normalized(n,d)
    e = 1 - d
    q = n;  qold = zero(T)
    while !iszero(k) && (qold != q) 
        k -= 1
        qold = q
        q = q * (1+e)
        e = e * e
    end
    return q
end

function Goldschmidt(n::FloatD64,d::FloatD64,k=4)}
    n1, d1 = normalized(n,d)
    e = 1 - d1
    q = n1;  qold = zero(T)
    while (qold != q) && !iszero(k)
       k -= 1
       qold = q
       q = q * (1+e) # q = q + q*e
       e = e * e
    end
    delta = (n1 - q*d1)/2
    return q + delta
end

=#
