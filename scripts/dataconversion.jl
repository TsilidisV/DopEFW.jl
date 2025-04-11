# Script for reading the excel file of the raw data and tranforming it into a nice to work with form

using DrWatson, Revise
quickactivate("F:\\Users\\Billy\\Documents\\Math\\Research\\2025_Sonographer\\DopEFW", "DopEFW")
using DopEFW
using DataFramesMeta, CSV

df = read_excel_sheets(datadir("raw", "data.xlsx"))
CSV.write(datadir("pro", "data.csv"), df)

df_pro = DataFrame(CSV.File(datadir("pro", "data.csv")))


dataset_names = get_sheet_names(datadir("raw", "data.xlsx"))

