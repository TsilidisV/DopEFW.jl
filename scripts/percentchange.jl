# Script for calculating the experiments of Section 4.2 titled "Interpretations of result"

using DrWatson, Revise
using DataFramesMeta, CSV
quickactivate("DopEFW")
using DopEFW

df_pro = DataFrame(CSV.File(datadir("pro", "data.csv")))
dfs = collect_results(datadir("simulations"))

fiftyvsninty(df_pro, jordaanII, "AC", 38)
fiftyvsninty(df_pro, jordaanII, "HC", 38)

fiftyvsninty(df_pro, hadlockI, "AC", 38)
fiftyvsninty(df_pro, hadlockI, "FL", 38)

fiftyvsninty(df_pro, hadlockII, "BPD", 38)
fiftyvsninty(df_pro, hadlockII, "FL", 38)
fiftyvsninty(df_pro, hadlockII, "AC", 38)

fiftyvsninty(df_pro, hadlockIV, "BPD", 38)
fiftyvsninty(df_pro, hadlockIV, "HC", 38)
fiftyvsninty(df_pro, hadlockIV, "AC", 38)
fiftyvsninty(df_pro, hadlockIV, "FL", 38)
@rsubset(@rsubset(dfs, :formula == hadlockIV, :dataset == "papageorghiou2014").result[1], :week == 38)

fiftyvsninty(df_pro, hadlockIII, "HC", 38)
fiftyvsninty(df_pro, hadlockIII, "AC", 38)
fiftyvsninty(df_pro, hadlockIII, "FL", 38)
@rsubset(@rsubset(dfs, :formula == hadlockIII, :dataset == "papageorghiou2014").result[1], :week == 38)




