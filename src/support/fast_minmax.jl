"""
    unsafe_min(x, y)
    unsafe_max(x, y)

of (x, y) obtain the one closer to -Inf [Inf], respectively
-  where x == y, obtain either

Only safe for use where neither x nor y is NaN
""" unsafe_min, unsafe_max

"""
    unsafe_minmag(x, y)
    unsafe_maxmag(x, y)
   
Only safe for use where neither x nor y is NaN
""" unsafe_minmag, unsafe_maxmag

unsafe_min(x::Float64, y::Float64) = signbit(x - y) ? x : y
unsafe_max(x::Float64, y::Float64) = signbit(y - x) ? x : y

unsafe_minmax(x::Float64, y::Float64) = ifelse(x < y, (x, y), (y, x))
unsafe_maxmin(x::Float64, y::Float64) = ifelse(y < x, (x, y), (y, x))

function fast_min(x::Float64, y::Float64) 
    x_minus_y = x - y
    signbit(x_minus_y) ? x : ifelse(!isnan(x_minus_y), y, NaN64)
end

function fast_max(x::Float64, y::Float64) 
    x_minus_y = x - y
    signbit(x_minus_y) ? y : ifelse(!isnan(x_minus_y), x, NaN64)
end

unsafe_minmag(x::Float64, y::Float64) = ifelse(abs(x) < abs(y), x, y)
unsafe_maxmag(x::Float64, y::Float64) = ifelse(abs(y) < abs(x), x, y)

function fast_minmag(x::Float64, y::Float64) 
    x_minus_y = abs(x) - abs(y)
    signbit(x_minus_y) ? x : ifelse(!isnan(x_minus_y), y, NaN64)
end

function fast_maxmag(x::Float64, y::Float64) 
    x_minus_y = abs(x) - abs(y)
    signbit(x_minus_y) ? y : ifelse(!isnan(x_minus_y), x, NaN64)
end

function unsafe_minmaxmag(x::Float64, y::Float64) 
    ifelse(abs(x) < abs(y), (x, y), (y, x))
end

function unsafe_maxminmag(x::Float64, y::Float64)
    ifelse(abs(y) < abs(x), (x, y), (y, x))
end
