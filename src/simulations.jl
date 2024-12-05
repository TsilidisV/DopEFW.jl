using DataFramesMeta, CSV
using GlobalSensitivity, QuasiMonteCarlo
using LinearAlgebra

"""
    simulation(formula::Formula, dataset::String; ci::Int = 10, path::String = "DopEFW\\data\\pro\\data.csv", samples::Int = 10^6) -> DataFrame

Performs a sensitivity analysis simulation using the specified formula and dataset, generating Sobol sensitivity indices.

# Arguments
- `formula::Formula`: An instance of the `Formula` struct that contains the function to evaluate and its parameters.
- `dataset::String`: The name of the dataset (paper) to filter the data for the simulation.
- `ci::Int`: The confidence interval percentile to use (default is 10).
- `path::String`: The file path to the CSV file containing the datasets (default is "DopEFW\\data\\pro\\data.csv").
- `samples::Int`: The number of samples to use for the Quasi-Monte Carlo simulation (default is 1,000,000).

# Returns
A `DataFrame` containing the results of the sensitivity analysis simulation, for each week of the dataset.

# Example
```julia
# Define a simple function and create a Formula instance

formula_instance = Formula(x -> x[1] + x[2], ["x1", "x2"], "Title of the Paper")

results = simulation(formula_instance, "DatasetName")
println(results)
```
"""
function simulation(formula::Formula, dataset::String; ci = 10, path = "DopEFW\\data\\pro\\data.csv", samples = 10^6)
    
    df = DataFrame(CSV.File(path))
    paper_data = @rsubset(df, :paper == dataset)

    lbs = hcat([@rsubset(paper_data, :percentile == "$(ci)", :parameter == p).value for p in formula.parameters]...)
    ubs = hcat([@rsubset(paper_data, :percentile == "$(100-ci)", :parameter == p).value for p in formula.parameters]...)
    weeks = @rsubset(paper_data, :percentile == "$(ci)", :parameter == formula.parameters[1]).week

    ind_names = indices_names(formula)

    # initializes an empty dataframe with just the column names being `indices_names`
    result = DataFrame(vcat(
                    "week" => Int64[],
                    [ind_name => Float64[] for (ind_name) in ind_names]
                    )
    )
    
    for i in 1:length(weeks)
        A, B = QuasiMonteCarlo.generate_design_matrices(samples, lbs[i, :], ubs[i, :], SobolSample())
        res = gsa(formula.func , Sobol(order = [0,1,2], nboot = 1), A, B)

        M = res.S2
        # M[triu(trues(size(M)), 1)] returns a vector of the elemets of the upper triangular matrix M,
        # by creating the upper triangular BitMatrix triu(trues(size(M)), 1).
        # Then, concatenates all the indices into a vector
        new_data = vcat(weeks[i], res.S1, M[triu(trues(size(M)), 1)], res.ST)

        # Pushes the indices to df
        push!(result, new_data)
    end

    return result
end