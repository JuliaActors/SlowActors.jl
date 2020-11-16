#
# This file is part of the SlowActors.jl Julia package, 
# MIT license, part of https://github.com/JuliaActors
#

# This tests if actors generated with SlowActors and Actors
# can communicate.
#
using SlowActors, Test

raise(a, b) = a^b

query(act, a, b) = request!(act, a, b) 

A = Actors.spawn(Func(raise))
B = spawn(Func(query, A))
@test request!(A, 2, 2) == 4
@test request!(B, 2, 2) == 4

A = spawn(Func(raise))
B = Actors.spawn(Func(query, A))
@test request!(A, 2, 2) == 4
@test request!(B, 2, 2) == 4
