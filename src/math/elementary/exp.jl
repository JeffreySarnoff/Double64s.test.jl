#=
   The Exponential Functions `exp(x)` and `exp(z)`.
   The associaed functions `expm1(x)` and `expm1(z)`.
=#

#=
   source: Efficient implementation of elementary functions in the medium-precision range
           by Fredrik Johansson
           section 3: Argument reduction

   result = exp(x)

   m = fld(x, log(2))
   t = x - m * log(2)

   exp(x) = exp(t) * (2.0^m)
            where t  in [0, log(2))

   exp(t) = (exp(t/(2.0^r)))^(2.0^r)
            where t/(2.0^r) in [0, 2.0^(-r))   # at the expense of r squarings

   if we precompute exp(i/(2^r)) for i = 0..(2^r - 1)
      we can write exp(x) = exp(x - i/2^r) * exp(i/2^r)  wher i = floor(x * 2^r)
      this achieves r halvings of argument reduction for the cost of a multiplication

=#
