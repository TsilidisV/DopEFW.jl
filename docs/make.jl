using DopEFW
using Documenter

DocMeta.setdocmeta!(DopEFW, :DocTestSetup, :(using DopEFW); recursive=true)

makedocs(;
    modules=[DopEFW],
    authors="Vasilis Tsilids",
    sitename="DopEFW.jl",
    format=Documenter.HTML(;
        canonical="https://TsilidisV.github.io/DopEFW.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/TsilidisV/DopEFW.jl",
    devbranch="master",
)
