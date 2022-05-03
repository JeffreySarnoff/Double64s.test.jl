@testset "Double64(x)" begin
  @test Hi(Double64(1.0)) === 1.0
  @test Lo(Double64(1.0)) === 0.0
  @test Hio(Double64(1.0)) === (1.0, 0.0)
  @test Double64(1.0e7, 1.0e-7) === Double64(1.00000000000001e7, -5.828380584716842e-10)  
  @test HiLo(Double64(1.0e7, 1.0e-7)) === (1.00000000000001e7, -5.828380584716842e-10)  
  @test HiLo(Double64((1.0e7, 1.0e-7))) === (1.0e7, 1.0e-7)
  @test Double64(BigFloat(pi)) === Double64((3.141592653589793, 1.2246467991473532e-16))
end

@testset "ComplexD64(x)" begin
end

@testset "T(::Double64)" begin
end

@testset "T(::ComplexD64)" begin
end
