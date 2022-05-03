#=
   multiplication by known constant
=#

# sigdigits = precision(Float64)-2
function find_consts_for_mulbyconst(c::BigFloat)
    b = round(c, sigdigits=51, base=2)
    chi = Double64(b)
    clo = Double64(c - chi)
    return chi, clo
end

function find_consts_for_divbyconst(c::BigFloat)
    return find_consts_for_mulbyconst(inv(c))
end

function mulbyconst(x::Double64, chi::Double64, clo::Double64)
    lo = clo * x
    hi = chi * x
    return hi + lo
end

divbyconst(x::Double64, chi::Double64, clo::Double64) = mulbyconst(x, chi, clo)
