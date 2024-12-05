using Chain, Combinatorics

"""
    indices_names(formula::Formula) -> Vector{String}

Generates names for the Sobol sensitivity indices based on the parameters defined in a given `Formula`.

# Arguments
- `formula::Formula`: An instance of the `Formula` struct, which contains the function, parameters, and associated paper.

# Returns
A vector of strings representing the names of the Sobol sensitivity indices. This includes combinations of the parameters and total order indices.

# Example
```julia

formula_instance = Formula(x -> x[1] + x[2], ["x", "y", "z"], "Title of the Paper")

index_names = indices_names(formula_instance)
println(index_names)  # Output: ["x", "y", "z", "x_y", "x_T", "y_T", "z_T"]
```
"""
function indices_names(formula::Formula)
    parameters = formula.parameters

    names = @chain parameters begin
        # returns the combinations of the split
        combinations()
        # collects the combinations
        collect()
        # returns only the combinations of size smaller than 3, since we won't calculate sobol indices of order larger than 2
        _[length.(_) .<= 2]
        # concatenats the strings of combinations
        join.("_")
        # adds the total order indices of the vars
        vcat(_, _[1:length(parameters)] .* "_T")
    end 

    return names
end