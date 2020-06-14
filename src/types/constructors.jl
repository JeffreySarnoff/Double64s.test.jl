TwoTupleF64(x::Float64) = (x, 0.0)
TwoTupleF64(x::Float64, y::Float64) = (x, y)

TwoTupleF64(x::ComplexF64, y::Float64) = (real(x), y)
TwoTupleF64(x::Float64, y::ComplexF64) = (x, real(y))
TwoTuplef64(x::ComplexF64, y::ComplexF64) = (real(x), real(y))

TwoTupleC64(x::Float64) = (Complex{Float64}(x,0.0), Complex{Float64}(0.0,0.0))
TwoTupleC64(x::Float64, y::Float64) = (Complex{Float64}(x,0.0), Complex{Float64}(y,0.0))

TwoTupleC64(x::ComplexF64) = (x, Complex{Float64}(0.0,0.0))
TwoTupleC64(x::ComplexF64, y::ComplexF64) = (x, y)
TwoTupleC64(x::ComplexF64, y::Float64) = (x, Complex{Float64}(y,0.0))
TwoTupleC64(x::Float64, y::ComplexF64) = (Complex{Float64}(x,0.0), y)
TwoTupleC64(x::Float64, y::Float64) = (Complex{Float64}(x,0.0), Complex{Float64}(y,0.0))

FloatD64(x::Float64) = FloatD64((x, 0.0))
FloatD64(x::Float64, y::Float64) = FloatD64(two_sum(x, y))

ComplexD64(x::Complex{Float64}) = ComplexD64((x, 0.0+0.0im))
ComplexD64(x::Complex{Float64}, y::Complex{Float64}) = ComplexD64(two_sum(x, y))
