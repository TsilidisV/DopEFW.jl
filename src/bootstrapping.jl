using DataFramesMeta
using Statistics, Random

"""
    bootstrap(data::Vector{T}, n_samples::Int, stat_func::Function, seed::Int) where T

Performs bootstrap resampling on a given dataset to compute statistics.

# Arguments
- `data::Vector{T}`: A vector of data points from which bootstrap samples will be drawn.
- `n_samples::Int`: The number of bootstrap samples to generate.
- `stat_func::Function`: A function that takes a vector of samples and returns a statistic (e.g., mean, median).
- `seed::Int`: An integer seed for the random number generator to ensure reproducibility.

# Returns
A vector of bootstrap statistics computed from the generated samples.
"""
function bootstrap(data::Vector{T}, n_samples::Int, stat_func::Function, seed::Int) where T
    # Create an array with random seeds
    seeds = rand(Xoshiro(seed), Int, n_samples)

    # Create an array to hold the bootstrap statistics
    bootstrap_stats = Vector{Float64}(undef, n_samples)
    
    # Generate bootstrap samples and compute statistics
    for i in 1:n_samples
        sample = rand(Xoshiro(seeds[i]), data, length(data))  # Sample with replacement
        bootstrap_stats[i] = stat_func(sample)  # Compute the statistic on the sample
    end
    
    return bootstrap_stats
end


"""
    df_bootstrap(simulations::DataFrame, formula::Formula; n_samples = 1000, stat_func = mean, seed = 1234)

Performs bootstrap resampling on a given formula from data from the simulation dataframe to compute statistics.

# Arguments
- `simulations::DataFrame`: A dataframe containing the simulations.
- `formula::Formula`: The `Formula` object that will be bootstrapped.
- `n_samples = 1000`: The number of bootstrap samples to generate.
- `stat_func = mean`: A function that takes a vector of samples and returns a statistic (e.g., mean, median).
- `seed = 1234`: The random seed

# Returns
A vector of bootstrap statistics computed from the generated samples.
"""
function df_bootstrap(simulations::DataFrame, formula::Formula; n_samples = 1000, stat_func = mean, seed = 1234)
    df = @chain simulations begin
        vcat(@rsubset(_, :formula == formula).result...)
        groupby(:week)
        combine(Not(:week) .=> (x -> [collect(x)]) .=> identity)
        transform(Not(:week) .=> ByRow( x -> bootstrap(x, n_samples, stat_func, seed)) .=> identity)
        transform(Not(:week) .=> ByRow(x -> median(x)  ) .=> (x -> x.*"50"),
                    Not(:week) .=> ByRow(x -> quantile(x, 0.05) ) .=> (x -> x.*"5"),
                    Not(:week) .=> ByRow(x -> quantile(x, 0.95) ) .=> (x -> x.*"95"),             
        )
    end

    names = DataFramesMeta.names(vcat(@rsubset(simulations, :formula == formula).result...))
    
    return select(df, Not(names), :week)
end