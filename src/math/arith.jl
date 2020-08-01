neg(x::T) where {T<:Number} = -x
rcp(x::T) where {T<:Number} = inv(x)
add(x::T, y::T) where {T<:Number} = x + y
sub(x::T, y::T) where {T<:Number} = x - y
mul(x::T, y::T) where {T<:Number} = x * y
divide(x::T, y::T) where {T<:Number} = x / y

for T in (:Float64, :(Complex{Float64}))
  @eval begin
    add(x::$T, y::$T) = x + y
    sub(x::$T, y::$T) = x - y
    mul(x::$T, y::$T) = x * y
    divide(x::$T, y::$T) = x / y
  end
end

for (T1,T2) in ((:Float64, :(Complex{Float64})), (:(Complex{Float64}), :Float64))
  @eval begin
    add(x::$T1, y::$T2) = add(promote(x, y)...)
    sub(x::$T1, y::$T2) = sub(promote(x, y)...)
    mul(x::$T1, y::$T2) = mul(promote(x, y)...)
    divide(x::$T1, y::$T2) = divide(promote(x, y)...)
  end
end

for T in (:FloatD64,)
  @eval begin  
    function neg(x::$T)
        return $T(-Hi(x), -Lo(x))
    end
    
    # relative error < 3u², 20 FP Ops
    # Algorithm 6 from [Joldes, Muller, Popescu 2017]
    function add(x::$T, y::$T)
        hi, lo   = two_sum(Hi(x), Hi(y))
        thi, tlo = two_sum(Lo(x), Lo(y))
        c = add(lo, thi)
        hi, lo = two_hilo_sum(hi, c)
        c = add(tlo, lo)
        hi, lo = two_hilo_sum(hi, c)
        return (hi, lo)
    end

    # relative error < 3u², 20 FP Ops
    # Algorithm 6 from [Joldes, Muller, Popescu 2017]
    # reworked for subtraction
    function sub(x::$T, y::$T)
        hi, lo   = two_diff(Hi(x), Hi(y))
        thi, tlo = two_diff(Lo(x), Lo(y))
        c = add(lo, thi)
        hi, lo = two_hilo_sum(hi, c)
        c = add(tlo, lo)
        hi, lo = two_hilo_sum(hi, c)
        return (hi, lo)
    end

    # relative error < 5u², 9 FP Ops
    # Algorithm 12 from [Joldes, Muller, Popescu 2017]
    function mul(x::$T, y::$T)
        hi, lo = two_prod(Hi(x), Hi(y))
        t = mul(Lo(x), Lo(y))
        t = fma(Hi(x), Lo(y), t)
        t = fma(Lo(x), Hi(y), t)
        t = add(lo, t)
        hi, lo = two_hilo_sum(hi, t)
        return (hi, lo)
    end

    # relative error < 9.8u², 31 FP Ops
    # Algorithm 18 from [Joldes, Muller, Popescu 2017] 
    function divide(x::$T, y::$T)
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
        return (hi, lo)
    end
    
    Base.:(+)(x::$T, y::$T) = add(x, y)
    Base.:(-)(x::$T, y::$T) = sub(x, y)
    Base.:(*)(x::$T, y::$T) = mul(x, y)
    Base.:(/)(x::$T, y::$T) = divide(x, y)
    Base.:(\)(x::$T, y::$T) = divide(y, x)

  end      
end
