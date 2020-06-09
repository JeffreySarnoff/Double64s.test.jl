FloatD64(x::Float64) = FloatD64((x, 0.0))
FloatD64(x::Float64, y::Float64) = FloatD64(two_sum(x, y))

ComplexD64(x::Complex{Float64}) = ComplexD64((x, 0.0+0.0im))
ComplexD64(x::Complex{Float64}, y::Complex{Float64}) = ComplexD64(two_sum(x, y))
