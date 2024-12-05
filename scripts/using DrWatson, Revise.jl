using DrWatson, Revise
quickactivate("F:\\Users\\Billy\\Documents\\Math\\Research\\2025_Sonographer\\DopEFW", "DopEFW")
using DopEFW
using DataFramesMeta, CSV

df = read_excel_sheets(datadir("raw", "data.xlsx"))
CSV.write(datadir("pro", "data.csv"), df)

df_pro = DataFrame(CSV.File(datadir("pro", "data.csv")))


dataset_names = get_sheet_names(datadir("raw", "data.xlsx"))



ρ1 = simulation(combs, "araujo2014")
ρ2 = simulation(combs, "briceno2013")
ρ3 = simulation(combs, "fouad2021")
ρ4 = simulation(combs, "giorlandino2009")

using CairoMakie

begin
    fig = Figure()
    ax = Axis(fig[1,1])
    scatterlines!(ax, ρ1.week, ρ1.AC; color = :blue)
    scatterlines!(ax, ρ2.week, ρ2.AC; color = :blue)
    scatterlines!(ax, ρ3.week, ρ3.AC; color = :blue)
    scatterlines!(ax, ρ4.week, ρ4.AC; color = :blue)

    scatterlines!(ax, ρ1.week, ρ1.FL; color = :red)
    scatterlines!(ax, ρ2.week, ρ2.FL; color = :red)
    scatterlines!(ax, ρ3.week, ρ3.FL; color = :red)
    scatterlines!(ax, ρ4.week, ρ4.FL; color = :red)

    scatterlines!(ax, ρ1.week, ρ1.HC; color = :purple)
    scatterlines!(ax, ρ2.week, ρ2.HC; color = :purple)
    scatterlines!(ax, ρ3.week, ρ3.HC; color = :purple)
    scatterlines!(ax, ρ4.week, ρ4.HC; color = :purple)

    fig
end