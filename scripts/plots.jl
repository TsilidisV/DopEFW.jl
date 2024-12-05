using DrWatson, Revise
quickactivate("F:\\Users\\Billy\\Documents\\Math\\Research\\2025_Sonographer\\DopEFW", "DopEFW")
using DopEFW
using DataFramesMeta
using CairoMakie

dfs = collect_results(datadir("simulations"))
dfb = collect_results(datadir("bootstraps"))


inch = 96
pt = 4/3
cm = inch / 2.54

fontsize = 10pt

function fig_maker(formula::Formula)
    fig = Figure(;
        size = (5.2inch, 2.1inch),
        fontsize = fontsize,
        fonts = (; regular = "Arial", bold = "Arial Bold")
        )
    ax = Axis(fig[1,1]; title = formula.paper, xlabel = "Week")

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
                color = param_color[params], marker = param_marker[params], label = params
        )
        CI5 = med = df_boot_res[:, params .* "5"]
        CI95 = med = df_boot_res[:, params .* "95"]
        rangebars!(ax, df_boot_res[:, "week"], CI5, CI95;
                color = param_color[params], whiskerwidth = 10
        )
    end
    Legend(fig[1,1, Right()], ax, framevisible = false)
    
    fig
end

fig = fig_maker(hadlockIV)


for formula in formula_vector
    name = figdir(savename(formula, "png"; allowedtypes = (String, Formula)))
    fig = fig_maker(formula)

    save(name, fig, px_per_unit = 400/inch)
end

figdir(args...) = projectdir("figures", args...)
