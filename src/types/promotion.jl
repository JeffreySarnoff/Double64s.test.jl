Base.promote_rule(::Type{ComplexD64}, ::Type{FloatD64}) = ComplexD64
Base.convert(::Type{ComplexD64}, x::FloatD64) = ComplexD64(x)

for T in (:Float64, :Float32, :Float16. :Int128, Int64, Int32, Int16, Int8)
  @eval begin
    Base.promote_rule(::Type{FloatD64}, ::Type{$T}) = FloatD64
    Base.convert(::Type{FloatD64}, x::$T) = FloatD64(x)
  end
end

