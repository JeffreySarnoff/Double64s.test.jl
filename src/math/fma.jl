#=
S. Boldo and J.M. Muller, 
Exact and Approximated Error of the FMA, 
IEEE Transactions on Computers, 60(2011), 157–164.

function fma_with_error(a::Float64, b::Float64, c::Float64)
    hi  = fma(a, b, c)
    u1, u2 = two_prod(a, b)
    v1, v2 = two_sum(c, u2)
    w1, w2 = two_sum(u1, v1)
    t = w1 - hi + w2
    md, lo = two_hilo_sum(t, v2)
    return hi, md, lo
end

  (a * b) + c == hi + md + lo
   fma(a,b,c) == hi
   |md + lo| = unit_roundoff_error(|hi|)/2
   |lo| = unit_roundoff_error(|md|)/2

function two_fma(a::Float64, b::Float64, c::Float64)
    hi  = fma(a, b, c)
    u1, u2 = two_prod(a, b)
    v1, v2 = two_sum(c, u2)
    w1, w2 = two_sum(u1, v1)
    md = (w1 - hi + w2) + v2
    return hi, md
end

=#

function Base.fma(xhi::T, xlo::T, yhi::T, ylo::T, zhi::T, zlo::T) where {T<:Float64}
   chi, c1 = two_prod(xhi, yhi)
   t0 = xlo * ylo
   t1 = fma(xhi, ylo, t0)
   c2 = fma(xlo, yhi, t1)
   c3 = c1 + c2
   dhi, dlo = two_hilo_sum(chi, c3)

   shi, slo = two_sum(zhi, dhi)
   thi, tlo = two_sum(zlo, dlo)
   c = slo + thi
   vhi, vlo = two_hilo_sum(shi, c)
   w = tlo + vlo
   hi, lo = two_hilo_sum(vhi, w)
   return FloatD64((hi, lo))
end

@inline function Base.fma(x::T, y::T, z::T) where {T<:FloatD64}
   return fma(Hi(x), Lo(x), Hi(y), Lo(y), Hi(z), Lo(z))
end

for T in (:FloatD64, :ComplexD64)
   @eval @inline function Base.muladd(x::$T, y::$T, z::$T)
      return x*y + z
   end
end

#=
   Quadruple-precision BLAS using Bailey's arithmetic with FMA instruction
   by S. Yamada, t. Ina, N. Sasa, Y.Idomura, M. Machida, T. Imamura
   2017 IEEE International Parallel and Distributed Processing Symposium Workshops
=#

function Base.:(*)(ahi::T, alo::T, bhi::T, blo::T) where {T<:Float64}
   p1 = ahi * bhi
   p2 = fma(ahi, bhi, -p1)
   p2 += alo*bhi + ahi*blo
   chi = p1 + p2
   clo = p2 - (chi - p1)
   return FloatD64((chi, clo))
end

@inline function Base.:(*)(a::T, b::T) where {T<:FloatD64}
   return (*)(Hi(a), Lo(a), Hi(b), Lo(b))
end
