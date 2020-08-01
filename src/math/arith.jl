neg(x::T) where {T<:Number} = -x
rcp(x::T) where {T<:Number} = inv(x)
add(x::T, y::T) where {T<:Number} = x + y
sub(x::T, y::T) where {T<:Number} = x - y
mul(x::T, y::T) where {T<:Number} = x * y
divide(x::T, y::T) where {T<:Number} = x / y

for T in (:Float64, :Complex{Float64})
  @eval begin
    add(x::$T, y::$T) = x + y
    sub(x::$T, y::$T) = x - y
    mul(x::$T, y::$T) = x * y
    divide(x::$T, y::$T) = x / y
  end
end

for (T1,T2) in ((:Float64, :Complex{Float64}), (:Complex{Float64}, :Float64))
  @eval begin
    add(x::$T, y::$T) = add(promote(x, y)...)
    sub(x::$T, y::$T) = sub(promote(x, y)...)
    mul(x::$T, y::$T) = mul(promote(x, y)...)
    divide(x::$T, y::$T) = divide(promote(x, y)...)
  end
end

for T in (:FloatD64, :TwoF64)
  @eval begin  
    function neg(x::$T)
        return $T(-hi(x), -lo(x))
    end
    
    function Base.abs(x::$T)
        return $T(abs(hi(x)), flipsign(lo(x), hi(x)))
    end
    
    function Base.abs2(x::$T)
        a = abs(x)
        return mul(a, a)
    end
    
    # relative error < 3u², 20 FP Ops
    # Algorithm 6 from [Joldes, Muller, Popescu 2017]
    function add(x::$T, y::$T)
        hi, lo   = two_sum(hi(x), hi(y))
        thi, tlo = two_sum(lo(x), lo(y))
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
        hi, lo   = two_diff(hi(x), hi(y))
        thi, tlo = two_diff(lo(x), lo(y))
        c = add(lo, thi)
        hi, lo = two_hilo_sum(hi, c)
        c = add(tlo, lo)
        hi, lo = two_hilo_sum(hi, c)
        return (hi, lo)
    end

    # relative error < 5u², 9 FP Ops
    # Algorithm 12 from [Joldes, Muller, Popescu 2017]
    function mul(x::$T, y::$T)
        hi, lo = two_prod(hi(x), hi(y))
        t = mul(lo(x), lo(y))
        t = fma(hi(x), lo(y), t)
        t = fma(lo(x), hi(y), t)
        t = add(lo, t)
        hi, lo = two_hilo_sum(hi, t)
        return (hi, lo)
    end

    # relative error < 9.8u², 31 FP Ops
    # Algorithm 18 from [Joldes, Muller, Popescu 2017] 
    function divide(x::$T, y::$T)
        negihi = -inv(hi(y))
        rhi = fma(hi(y), negihi, 1.0) 
        rlo = mul(lo(y), ihi)
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
