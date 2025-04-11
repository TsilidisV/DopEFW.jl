# Script for producing Figure 3, containing the ranges of the parameters

using DrWatson, Revise
using CairoMakie
using DataFramesMeta, CSV
using Statistics
quickactivate("DopEFW")
using DopEFW

path = "data\\pro\\data.csv"

df = @chain DataFrame(CSV.File(path)) begin
    @rsubset!(:week !== 43 && :week !== 44)
    @rsubset!(:percentile == "10" || :percentile == "90" || :percentile == "50")
    groupby( [:parameter, :week, :percentile])
    combine(:value => median)
end

@rsubset(df, :week == 10, :percentile == "50").value_median |> std
@rsubset(df, :week == 42, :percentile == "50").value_median |> std

week_ticks = unique(df.week)

inch = 96
pt = 4/3
cm = inch / 2.54
fontsize = 10pt

param_fig = with_theme() do 
        fig = Figure(;
        size = (5.2inch, 3.1inch),
        fontsize = fontsize,
        fonts = (; regular = "Arial", bold = "Arial Bold")
    )

    ax = Vector{Axis}(undef, 4)
    for (i, param) in enumerate(["BPD", "HC", "AC", "FL"])
        idx = numtogrid(i, 2)
        ax[i] = Axis(fig[idx[:row], idx[:col]];
                title = param,
                xlabel = "Week",
                ylabel = "Measurement (cm)",   
        )

        data = Vector{Vector{Float64}}(undef, 3)
        for (j, cent) in enumerate(["10", "50", "90"])
            data[j] = @rsubset(df, :percentile == cent, :parameter == param).value_median
        end
    
        lines!(ax[i], week_ticks, data[2];
                        color = param_color[param],
                        #marker = param_marker[param]   
            )

        band!(ax[i], week_ticks,  data[1], data[3];
                        color = param_color[param],
                        alpha = 0.6
            )        
    end
    
    fig
end

save(figdir("parameter_ranges.png"), param_fig, px_per_unit = 400/inch)








