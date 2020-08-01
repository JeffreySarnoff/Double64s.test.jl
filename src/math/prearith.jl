Base.signbit(x::FloatD64) = signbit(Hi(x))
Base.sign(x::FloatD64) = sign(Hi(x))
signs(x::FloatD64) = (sign(Hi(x), sign(Lo(x)))
Base.significand(x::FloatD64) = (significand(Hi(x)), significand(Lo(x)))
Base.exponent(x::FloatD64) = (exponent(Hi(x)), exponent(Lo(x)))

Base.:(-)(x::FloatD64) = FloatD64((-Hi(x), -Lo(x)))
Base.abs(x::FloatD64) = signbit(x) ? -x : x
Base.abs2(x::FloatD64) = x*x
Base.copysign(x::FloatD64, y) = signbit(y) ? -abs(x) : abs(x)
Base.flipsign(x::FloatD64, y) = signbit(y) ? -x : x

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

function Base.trunc(x::FloatD64)
    return signbit(x) ? ceil(x) : floor(x)
end

