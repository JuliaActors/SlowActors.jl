#
# This file is part of the SlowActors.jl Julia package, 
# MIT license, part of https://github.com/JuliaActors
#
"""
    SlowActors

A minimal Julia actors library for using the `Actors` interface.

It is not registered since it has demonstrative purpose. 
You can install it by:

```julia
pkg> add "https://github.com/JuliaActors/SlowActors.jl"
```
"""
module SlowActors

"Gives the package version."
const version = v"0.1.0"

using Reexport, DataStructures, Distributed

@reexport using Actors

include("types.jl")
include("actor.jl")
include("com.jl")

export newLink, spawn

end
