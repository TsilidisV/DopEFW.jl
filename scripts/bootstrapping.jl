# Script to create a 10^6 bootstrap sample of the mean value of all indices for each formula
# The script saves the median of the estimation along with a 95% CI

using DrWatson, Revise
quickactivate("F:\\Users\\Billy\\Documents\\Math\\Research\\2025_Sonographer\\DopEFW", "DopEFW")
using DopEFW
using DataFramesMeta, CSV
using Statistics

df = collect_results(datadir("simulations"))

n_samples = [10^6]
seed = [1234]
formula = formula_vector
p_dict = @strdict formula n_samples seed
dicts = dict_list(p_dict)

function single_dict(dict)
    @unpack formula, n_samples, seed = dict
    result = df_bootstrap(df, formula; n_samples = n_samples, stat_func = mean, seed = seed)
    new_dict = copy(dict)
    new_dict["result"] = result
    return new_dict
end

for dict in dicts
    produce_or_load(single_dict, dict, datadir("bootstraps"); 
        filename = savename(dict, allowedtypes = (Vector,Real,Function, String, Formula))
    )
end