using SlowActors
using Documenter

makedocs(;
    modules=[SlowActors],
    authors="Paul Bayer",
    repo="https://github.com/JuliaActors/SlowActors.jl/blob/{commit}{path}#L{line}",
    sitename="SlowActors.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JuliaActors.github.io/SlowActors.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "API" => "api.md"
    ],
)

deploydocs(;
    repo="github.com/JuliaActors/SlowActors.jl",
)
