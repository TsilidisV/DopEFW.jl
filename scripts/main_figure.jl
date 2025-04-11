# Script for producing Figure 4, containing the main results of the paper

using DrWatson, Revise
using DataFramesMeta
using CairoMakie, LaTeXStrings
using XLSX
quickactivate("DopEFW")
using DopEFW


dfs = collect_results(datadir("simulations"))
dfb = collect_results(datadir("bootstraps"))

file_path = datadir("metadata/metadata.xlsx") # Define the file path
metadata_dict = metadata_getter(file_path)

inch = 96
pt = 4/3
cm = inch / 2.54
fontsize = 8pt

figdir(args...) = projectdir("figures", args...)

function one_plot!(ax, formula::Formula)

    df_formula = @rsubset dfs :formula == formula
    df_boot = @rsubset dfb :formula == formula
    df_boot_res = @rsubset df_boot.result[1] :week <= 42


    for params in formula.parameters

        for df_f in eachrow(df_formula)
            scatterlines!(ax, df_f.result.week, df_f.result[!, params]; 
                color = (param_color[params], 0.05), marker = param_marker[params]  
            )
        end

        weeks = df_boot_res[:, "week"]
        med =df_boot_res[:, params .* "50"]
        scatter!(ax, df_boot_res[:, "week"], df_boot_res[:, params .* "50"];
                color = param_color[params], marker = param_marker[params], label = params,
                markersize = 8
        )
        CI5 = med = df_boot_res[:, params .* "5"]
        CI95 = med = df_boot_res[:, params .* "95"]
        rangebars!(ax, df_boot_res[:, "week"], CI5, CI95;
                color = param_color[params], whiskerwidth = 7
        )
    end
    #Legend(fig[1, 1, Right()], ax, framevisible = false, tellwidth = :true)
    
    return ax
end


function big_fig_maker(formulas::Vector)
    fig = Figure(;
        fontsize = fontsize,
        fonts = (; regular = "Arial", bold = "Arial Bold")
        )

    ax = Vector{Axis}(undef, length(formulas))

    for (i, formula) in enumerate(formulas)
        ax[i] = Axis(fig[numtogrid(i,2)[:row], numtogrid(i,2)[:col]];
            width = 5.7inch/2, height = 1.4inch, #rsos dimensions
            #width = 5.7inch/2, height = 1.0inch, # arxiv dimensions
            title = formula.paper, titlesize = 10pt,
            xminorticks = IntervalsBetween(2),
            xminorticksvisible = true, xminorgridvisible = true,
            xlabel = "Week",
            yticks = LinearTicks(5),
            subtitle = latexstring(metadata_dict[formula.paper]), subtitlesize = 9pt
        )

        one_plot!(ax[i], formula)
    end

    Legend(fig[end+1,:], ax[2]; framevisible = false,
        orientation = :horizontal,
        padding = (0, 0, -10, -10)
    )

    resize_to_layout!(fig)
    fig
end

fig = big_fig_maker([hadlockII, hadlockIV, halaska, intergrowth17, merz, shepardI, weinerII, woo])

save(figdir("results_ross.png"), fig, px_per_unit = 400/inch)