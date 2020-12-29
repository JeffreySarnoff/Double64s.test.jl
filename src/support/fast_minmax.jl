"""
    unsafe_min(x, y)
    unsafe_max(x, y)
    
Only safe for use where neither x nor y is NaN
""" unsafe_min, unsafe_max

unsafe_min(x::Float64, y::Float64) = signbit(x - y) ? x : y
unsafe_max(x::Float64, y::Float64) = signbit(y - x) ? x : y

function fast_min(x::Float64, y::Float64) 
    x_minus_y = x - y
    signbit(x_minus_y) ? x : ifelse(!isnan(x_minus_y), y, NaN64)
end

function fast_max(x::Float64, y::Float64) 
    x_minus_y = x - y
    signbit(x_minus_y) ? y : ifelse(!isnan(x_minus_y), x, NaN64)
end

function unsafe_minmax(x::Float64, y::Float64) 
    (unsafe_min(x,y), unsafe_max(x,y))
end

function unsafe_maxmin(x::Float64, y::Float64)
    (signbit(y-x) || isnan(x)) ? (x,y) : (y,x)
end
