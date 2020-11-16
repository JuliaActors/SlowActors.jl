#
# This file is part of the SlowActors.jl Julia package, 
# MIT license, part of https://github.com/JuliaActors
#

using SlowActors, Test, .Threads

a = Ref{Int}()
a[] = 1

inca(a, b) = a[] = a[] + b

slow = spawn(Func(inca, a))

send!(slow, 1)
sleep(0.1)
@test a[] == 2
@test request!(slow, 1) == 3
@test a[] == 3
become!(slow, threadid)
@test request!(slow) > 1

slow1 = spawn(Func(threadid), sticky=true)
@test request!(slow1) == 1
