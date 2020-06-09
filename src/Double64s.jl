module Double64s

export FloatD64, ComplexD64,
  hi, lo, hilo

const TwoTupleF64 = Tuple{Float64, Float64}
const TwoTupleC64 = Tuple{Complex{Float64}, Complex{Float64}}

struct FloatD64 <: Real
    val::TwoTupleF64
end

struct ComplexD64 <: Complex
    val::TwoTupleC64
end

hi(x::FloatD64) = x.val[1]
lo(x::FloatD64) = x.val[2]
hilo(x::FloatD64) = x.val

hi(x::ComplexD64) = x.val[1]
lo(x::ComplexD64) = x.val[2]
hilo(x::ComplexD64) = x.val

hi(x::Float64) = x
lo(x::Float64) = 0.0
hilo(x::Float64) = (x, 0.0)

hi(x::Complex{Float64}) = x
lo(x::Complex{Float64}) = 0.0+0.0im
hilo(x::Complex{Float64}) = (x, 0.0+0.0im)

end  # Double64s
