onethird(::Type{Float64}) = 0.3333333333333333
onethird(::Type{FloatD64}) = FloatD64((0.3333333333333333, 1.850371707708594e-17))

function Base.sqrt(x::FloatD64)
    x0 = sqrt(Hi(x))
    x1 = (x0 + x/x0) * 0.5
    x2 = (x1 + x/x1) * 0.5
    return x2
end
 
function fastsqrt(x::FloatD64)
    x0 = sqrt(Hi(x))
    x1 = (x0 + x/x0) * 0.5
    return x1
end

function Base.cbrt(x::FloatD64)
    x0 = cbrt(Hi(x))
    a = (4*x/x0) - x9*x0
    b = fastsqrt(a)
    x1 = (x0 + b/3)/2
    #x1 = (x0 + sqrt(((4*p/x0)-x0^2)/3))/2
    # x1 = (2*x0 + x/(x0*x0)) / 3.0
    x2 = (2*x1 + x/(x1*x1)) / 3.0
    #x3 = (2*x2 + x/(x2*x2)) / 3.0
    return x2
end
 
function fastcbrt(x::FloatD64)
    x0 = cbrt(Hi(x))
    x1 = (2*x0 + x/(x0*x0)) / 3.0
    x2 = (2*x1 + x/(x1*x1)) / 3.0
    return x2
end
