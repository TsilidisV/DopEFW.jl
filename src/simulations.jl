using DataFramesMeta, CSV
using GlobalSensitivity, QuasiMonteCarlo
using LinearAlgebra

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