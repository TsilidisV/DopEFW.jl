using DataFramesMeta

"""
    percent_change(df_pro::DataFrame, formula::Formula, param::String, week::Int; dataset::String = "papageorghiou2014")

Calculates the percent change between two sets of values derived from a DataFrame based on specified parameters and a given week.

# Arguments
- `df_pro::DataFrame`: A DataFrame containing the data to be analyzed. It should include columns for 'paper', 'percentile', 'parameter', 'week', and 'value'.
  
- `formula::Formula`: An object that contains:
  - `parameters`: A list of parameter names (Strings) used in the calculations.
  - `func`: A function that takes an array of values and returns a computed result.

- `param::String`: The name of the parameter for which the percent change is to be calculated. This must be one of the parameters defined in `formula`.

- `week::Int`: The specific week (as an integer) for which the data is being analyzed.

- `dataset::String`: (Optional) The name of the dataset to filter by. Defaults to "papageorghiou2014".

# Returns
A tuple containing:
- `res1`: The result of applying the formula to the first set of values (from percentile 50).
- `res2`: The result of applying the formula to the modified set of values (where `param` of percentile 50 is replaced by percentile 90).
- `percent_change`: The calculated percent change between `res1` and `res2`, expressed as a fraction.
"""
function fiftyvsninty(df_pro::DataFrame, formula::Formula, param::String, week::Int; dataset = "papageorghiou2014")
    index = findfirst(isequal(param), formula.parameters)
    if index == nothing
        throw(DomainError(param, "Provide a valid parameter of the formula"))
        return nothing
    end
    
    paper_data = @rsubset(df_pro, :paper == dataset)

    ci1 = 50
    ch1 = hcat([@rsubset(paper_data, :percentile == "$(ci1)", :parameter == p, :week == week).value for p in formula.parameters]...)
    ci2 = 90
    ch2 = hcat([@rsubset(paper_data, :percentile == "$(ci2)", :parameter == p, :week == week).value for p in formula.parameters]...)
    ch1v2 = copy(ch1)
    ch1v2[index] = ch2[index]

    res1 = formula.func(ch1)
    res2 = formula.func(ch1v2)
    return res1, res2, (res2 - res1) / res1
end