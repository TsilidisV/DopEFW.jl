using DataFramesMeta
using Statistics, Random

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