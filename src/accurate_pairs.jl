using Base: IEEEFloat

#=

  - error-free transformations (`two_sum`, `two_diff`, `two_square`, `two_prod`,
                                `two_hilo_sum`, `two_lohi_sum`, `two_hilo_diff`, `two_lohi_diff`)
  - least-error transformations (`two_sqrt`, `two_inv`, `two_div`)

 nomenclature: 
 - `two_<op>`: the "two" refers to the number of values returned
    two and three argument versions of `two_[sum,diff,prod]` are given
 - `two_hilo_<op>` the argments are ordered by non-increasing absolute value
    - this is `fast_two_sum` in the literature
 - `two_lohi_<op>` the argments are ordered by non-decreasing absolute value
    - this is not available in the literature

=#

"""
    two_sum(a, b)
    
Computes `hi = fl(a+b)` and `lo = err(a+b)`.
- Unchecked Precondition: !(isinf(a) | isinf(b))
"""
@inline function two_sum(a::T, b::T) where {T}
    hi = a + b
    v  = hi - a
    lo = (a - (hi - v)) + (b - v)
    return hi, lo
end

"""
   two_sum(a, b, c)
    
Computes `hi = fl(a+b+c)` and `lo = err(a+b+c)`.
- Unchecked Precondition: !(isinf(a) | isinf(b) | isinf(c))
"""
function two_sum(a::T, b::T, c::T) where {T}
    a, b, c = magnitude_mintomax(a, b, c)
    md, lo = two_sum(b, c) 
    hi, md = two_sum(a, md)
    hi, lo = two_hilo_sum(hi, md+lo)
    return hi, lo
end

"""
    two_diff(a, b)

Computes `s = fl(a-b)` and `e = err(a-b)`.
- Unchecked Precondition: !(isinf(a) | isinf(b))
"""
@inline function two_diff(a::T, b::T) where {T}
    hi = a - b
    v  = hi - a
    lo = (a - (hi - v)) - (b + v)
    return hi, lo
end

"""
    two_diff(a, b, c)
    
Computes `s = fl(a-b-c)` and `e1 = err(a-b-c), e2 = err(e1)`.
- Unchecked Precondition: !(isinf(a) | isinf(b) | isinf(c))
"""
function two_diff(a::T,b::T,c::T) where {T}
    a, b, c = magnitude_maxtomin(a, b, c)
    s, t = two_diff(-b, c)
    hi, u = two_sum(a, s)
    hi, lo = two_hilo_sum(hi, u+t)
    return hi, lo
end


"""
    two_hilo_sum(a, b)

*unchecked* requirement `|a| ≥ |b|`
Computes `hi = fl(a+b)` and `lo = err(a+b)`.
- Unchecked Precondition: !(isinf(a) | isinf(b))
"""
@inline function two_hilo_sum(a::T, b::T) where {T}
    hi = a + b
    lo = b - (hi - a)
    return hi, lo
end

"""
    two_lohi_sum(a, b)

*unchecked* requirement `|b| ≥ |a|`
Computes `hi = fl(a+b)` and `lo = err(a+b)`.
- Unchecked Precondition: !(isinf(a) | isinf(b))
"""
@inline function two_lohi_sum(a::T, b::T) where {T}
    hi = b + a
    lo = a - (hi - b)
    return hi, lo
end

"""
    two_hilo_diff(a, b)
    
*unchecked* requirement `|a| ≥ |b|`
Computes `hi = fl(a-b)` and `lo = err(a-b)`.
- Unchecked Precondition: !(isinf(a) | isinf(b))
"""
@inline function two_hilo_diff(a::T, b::T) where {T}
    hi = a - b
    lo = (a - hi) - b
    hi, lo
end

"""
    two_lohi_diff(a, b)
    
*unchecked* requirement `|b| ≥ |a|`
Computes `hi = fl(a-b)` and `lo = err(a-b)`.
- Unchecked Precondition: !(isinf(a) | isinf(b))
"""
@inline function two_lohi_diff(a::T, b::T) where {T}
    hi = b - a
    lo = (b - hi) - a
    hi, lo
end

"""
    two_square(a)

Computes `hi = fl(a*a)` and `lo = fl(err(a*a))`.
- Unchecked Precondition: !(isinf(a))
"""
@inline function two_square(a::T) where {T}
    hi = a * a
    lo = fma(a, a, -hi)
    hi, lo
end

"""
    two_prod(a, b)

Computes `hi = fl(a*b)` and `lo = fl(err(a*b))`.
- Unchecked Precondition: !(isinf(a) | isinf(b))
"""
@inline function two_prod(a::T, b::T) where {T}
    hi = a * b
    lo = fma(a, b, -hi)
    hi, lo
end

"""
    two_prod(a, b, c)
    
Computes `hi = fl(a*b*c)` and `lo = err(a*b*c)`.
- Unchecked Precondition: !(isinf(a) | isinf(b) | isinf(c))
"""
function two_prod(a::T, b::T, c::T) where {T}
    abhi, ablo = two_prod(a, b)
    hi, abhiclo = two_prod(abhi, c)
    ablochi, abloclo = two_prod(ablo, c)
    lo = ablochi + (abhiclo + abloclo)
    return hi, lo
end

"""
    two_inv(a)
    
Computes `hi = fl(inv(a))` and `lo = err(inv(a))`.
- Unchecked Precondition: !(isinf(a))
"""
@inline function two_inv(a::T) where {T}
     hi = inv(a)
     lo = fma(-hi, a, one(T))
     lo /= a
     return hi, lo
end

"""
    two_div(a, b)
    
Computes `hi = fl(a/b)` and `lo = err(a/b)`.
- Unchecked Precondition: !(isinf(a) | isinf(b))
"""
@inline function two_div(a::T, b::T) where {T}
     hi = a / b
     lo = fma(-hi, b, a)
     lo /= b
     return hi, lo
end

"""
    two_sqrt(a)
    
Computes `hi = fl(sqrt(a))` and `lo = err(sqrt(a))`.
- Unchecked Precondition: !(isinf(a))
"""
@inline function two_sqrt(a::T) where {T}
    hi = sqrt(a)
    lo = fma(-hi, hi, a)
    lo /= 2
    lo /= hi
    return hi, lo
end



Base.:(+)(xhi::T, xlo::T, y::T) where {T<:IEEEFloat} = two_sum(xhi, y, xlo)
Base.:(-)(xhi::T, xlo::T, y::T) where {T<:IEEEFloat} = two_sum(xhi, xlo, -y)

Base.:(+)(x::Tuple{T,T}, y::T) where {T<:IEEEFloat} = (+)(x[1], x[2], y)
Base.:(-)(x::Tuple{T,T}, y::T) where {T<:IEEEFloat} = (+)(x[1], x[2], y)

# Algorithm 12 from Tight and rigourous error bounds.  relative error <= 5u²
function Base.:(*)(xhi::T, xlo::T, y::T) where {T<:IEEEFloat}
    hi, lo = two_prod(xhi, y)
    t = fma(xlo, y, lo)
    hi, lo = two_hilo_sum(hi, t)
    return hi, lo
end

function Base.:(/)(xhi::T, xlo::T, y::T) where {T<:IEEEFloat}
    hi = xhi / y
    uh, ul = two_prod(hi, y)
    lo = ((((xhi - uh) - ul) + xlo))/y
    hi,lo = two_hilo_sum(hi, lo)
    return hi, lo
end

Base.:(*)(x::Tuple{T,T}, y::T) where {T<:IEEEFloat} = (*)(x[1], x[2], y)
Base.:(/)(x::Tuple{T,T}, y::T) where {T<:IEEEFloat} = (/)(x[1], x[2], y)

# exchange sort for magnitudes, 2 or 3 values

@inline magnitude_minmax(a, b) = abs(a) < abs(b) ? (a, b) : (b, a)

@inline function magnitude_mintomax(a, b, c)
    b, c = magnitude_minmax(b, c)
    a, c = magnitude_minmax(a, c)
    a, b = magnitude_minmax(a, b)
    return a, b, c
end
