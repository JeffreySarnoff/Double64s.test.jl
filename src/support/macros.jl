#=
   This is a copy of `@forward` and `isexpr` from `Lazy.jl` (Mike Innes)
   here it is renamed `@usefield` to avoid clashing with `Lazy.jl`
   <https://github.com/MikeInnes/Lazy.jl/blob/master/src/macros.jl>
=#

"""
    @usefield T.x functions...
    
Define methods for `functions` on type `T`, 
which call the relevant function on the field `x`.

# Example
```julia
struct Wrapper
    x
end
@usefield Wrapper.x  Base.sqrt                                  # now sqrt(Wrapper(4.0)) == 2.0
@usefield Wrapper.x  Base.length, Base.getindex, Base.iterate   # several forwarded functions are put in a tuple
@usefield Wrapper.x (Base.length, Base.getindex, Base.iterate)  # equivalent to above
```
"""
macro usefield(ex, fs)
  @capture(ex, T_.field_) || error("Syntax: @forward T.x f, g, h")
  T = esc(T)
  fs = isexpr(fs, :tuple) ? map(esc, fs.args) : [esc(fs)]
  :($([:($f(x::$T, args...; kwargs...) = (Base.@_inline_meta; $f(x.$field, args...; kwargs...)))
       for f in fs]...);
    nothing)
end


"""
    isexpr(x, ts...)

Convenient way to test the type of a Julia expression.
Expression heads and types are supported, so for example
you can call
    isexpr(expr, String, :string)
to pick up on all string-like expressions.
"""
isexpr(x::Expr) = true
isexpr(x) = false
isexpr(x::Expr, ts...) = x.head in ts
isexpr(x, ts...) = any(T->isa(T, Type) && isa(x, T), ts)

