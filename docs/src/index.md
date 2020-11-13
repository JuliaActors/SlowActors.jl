```@meta
CurrentModule = SlowActors
```

# SlowActors

A "slow" actor library to test the interface with `Actors.jl`.

SlowActors implements the minimal actor primitives defined by `Actors.jl` in a different way in order to

- prove that they are sufficient to run the basic examples,
- show that actors from both libraries can communicate,
- make API functions and applications of `Actors.jl` run with `SlowActors`,
- give an example how the interface of `Actors.jl` can be implemented in another library.

```@index
```

```@autodocs
Modules = [SlowActors]
```
