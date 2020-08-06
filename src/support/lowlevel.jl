function Base.modf(x::FloatD64)
    frc_hi, int_hi = modf(Hi(x))
    frc_lo, int_lo = modf(Lo(x))
    frc_part = FloatD64(two_hilo_sum(frc_hi, frc_lo))
    int_part = FloatD64(two_hilo_sum(int_hi, int_lo))
    return (frc_part, int_part)
end

fmod(parts::Tuple{FloatD64, FloatD64}) = fmod(parts...)
function fmod(frc_part::FloatD64, int_part::FloatD64)
    return int_part + frc_part
end
