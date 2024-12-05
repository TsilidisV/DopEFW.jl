module DopEFW

export read_excel_sheets, get_sheet_names, split_string
include("dataloader.jl")

export Formula, formula_vector, 
    combs, ferrero, hadlock, hadlockI, hadlockII, hadlockIII, hadlockIV, halaska, hsieh, intergrowth17, jordaanI, jordaanII, 
    merz, ott, roberts, schild, shepardI, shepardII, siemer, thurnau, vintzileosI, warsof1977, warsof1986, weinerI, weinerII, woo, wooI, wooII, wooIII, wooIV, wooV
include("EFWFormulas.jl")

export indices_names
include("FormulasUtilis.jl")

export simulation
include("simulations.jl")

export param_color, param_marker
include("figures.jl")

export bootstrap, df_bootstrap
include("bootstrapping.jl")

end
