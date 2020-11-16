#
# This file is part of the SlowActors.jl Julia package, 
# MIT license, part of https://github.com/JuliaActors
#

using Test, SafeTestsets

function redirect_devnull(f)
    open(@static(Sys.iswindows() ? "nul" : "/dev/null"), "w") do io
        redirect_stdout(io) do
            f()
        end
    end
end

@safetestset "Basics"       begin include("test_basics.jl") end
@safetestset "Interface"    begin include("test_interface.jl") end

println("running examples, output suppressed!")
redirect_devnull() do
    @safetestset "Factorial"     begin include("../examples/factorial.jl") end
    @safetestset "Fib"           begin include("../examples/fib.jl") end
    @safetestset "Simple"        begin include("../examples/simple.jl") end
    @safetestset "Stack"         begin include("../examples/stack.jl") end
end
