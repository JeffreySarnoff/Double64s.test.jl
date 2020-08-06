#=
   multiplication by known constant
=#

# sigdigits = precision(Float64)-2
function find_consts_for_mulbyconst(c::BigFloat)
    b = round(c, sigdigits=51, base=2)
    chi = FloatD64(b)
    clo = FloatD64(c - chi)
    return chi, clo
end

function find_consts_for_divbyconst(c::BigFloat)
    return find_consts_for_mulbyconst(inv(c))
end

function mulbyconst(x::FloatD64, chi::FloatD64, clo::FloatD64)
    lo = clo * x
    hi = chi * x
    return hi + lo
end

divbyconst(x::FloatD64, chi::FloatD64, clo::FloatD64) = mulbyconst(x, chi, clo)
