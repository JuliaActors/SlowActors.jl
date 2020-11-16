# SlowActors

A "slow" actor library to test the interface with `Actors.jl`.

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaActors.github.io/SlowActors.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaActors.github.io/SlowActors.jl/dev)
[![Build Status](https://github.com/JuliaActors/SlowActors.jl/workflows/CI/badge.svg)](https://github.com/JuliaActors/SlowActors.jl/actions)
[![Coverage](https://codecov.io/gh/JuliaActors/SlowActors.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaActors/SlowActors.jl)

**Note:** CI will not run until `Actors.jl` v0.1.1 is registered!

SlowActors implements the minimal actor primitives defined by `Actors.jl` in a different way in order to

- prove that they are sufficient to run the basic examples,
- show that actors from both libraries can communicate,
- make API functions and applications of `Actors.jl` run with `SlowActors`,
- give an example how the interface of `Actors.jl` can be used in another library.

## Author(s)

- Paul Bayer

## License

MIT
