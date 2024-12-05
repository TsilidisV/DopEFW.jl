using Chain, Combinatorics

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