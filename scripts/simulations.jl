# Script for running and saving of the simulations

using DrWatson, Revise
quickactivate("DopEFW")
using DopEFW

dataset_names = get_sheet_names(datadir("raw", "data.xlsx"))

function dict_sim(dicts::Vector)
    for dict in dicts
        @unpack formula, dataset = dict
        result = simulation(formula, dataset)
        new_dict = copy(dict)
        new_dict["result"] = result
        wsave(
            datadir("simulations",
                savename(dict, "jld2", allowedtypes = (Vector,Real,Function, String, Formula))
            ), new_dict
        )
    end
end

vector = [combs, ferrero, hadlockI, hadlockII, hadlockIII, hadlockIV, halaska, hsieh, intergrowth17, jordaanI, jordaanII, 
merz, ott, roberts, schild, shepardI, shepardII, siemer, thurnau, vintzileosI, warsof1977, weinerI, weinerII, woo, wooI, wooII, wooIII, wooIV, wooV]

formula = vector
dataset = get_sheet_names(datadir("raw", "data.xlsx"))

p_dict = @strdict formula dataset
dicts = dict_list(p_dict)

function single_dict(dict)
    @unpack formula, dataset = dict
    result = simulation(formula, dataset)
    new_dict = copy(dict)
    new_dict["result"] = result
    return new_dict
end

for dict in dicts
    produce_or_load(single_dict, dict, datadir("simulations"); 
        filename = savename(dict, allowedtypes = (Vector,Real,Function, String, Formula))
    )
end

