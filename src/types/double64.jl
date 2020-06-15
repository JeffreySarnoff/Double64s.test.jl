const TwoF64 = Tuple{Float64, Float64}
const TwoC64 = Tuple{Complex{Float64}, Complex{Float64}}
const Two64 = Union{TwoF64, TwoC64}

struct FloatD64 <: Real
    val::TwoF64
end

struct ComplexD64 <: Number
    val::TwoC64
end

const FloatCmplxD64 = Union{FloatD64, ComplexD64}

hi(x::TwoF64) = x[1]
lo(x::TwoF64) = x[2]
hilo(x::TwoF64) = x

hi(x::TwoC64) = x[1]
lo(x::TwoC64) = x[2]
hilo(x::TwoC64) = x

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
