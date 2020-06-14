@testset "FloatD64(x)" begin
  @test hi(FloatD64(1.0)) === 1.0
  @test lo(FloatD64(1.0)) === 0.0
  @test hilo(FloatD64(1.0)) === (1.0, 0.0)
  # @test FloatD64(1.0e7, 1.0e-7) === FloatD64(1.00000000000001e7, -5.828380584716842e-10)  
  # @test hilo(FloatD64(1.0e7, 1.0e-7)) === (1.00000000000001e7, -5.828380584716842e-10)  
  @test hilo(FloatD64((1.0e7, 1.0e-7))) === (1.0e7, 1.0e-7)  
end

@testset "ComplexD64(x)" begin
end

@testset "T(::FloatD64)" begin
end

@testset "T(::ComplexD64)" begin
end
