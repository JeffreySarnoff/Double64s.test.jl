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
