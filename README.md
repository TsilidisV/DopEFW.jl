# **D**ependence **o**f ultrasonical **p**arametrs on **E**stimated **F**etal **W**eight (DopEFW)

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://TsilidisV.github.io/DopEFW.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://TsilidisV.github.io/DopEFW.jl/dev/)
[![Build Status](https://github.com/TsilidisV/DopEFW.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/TsilidisV/DopEFW.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

A julia package for investigating the significance of the ultrasonically measured biometric parameters:
- _biparietal diameter_ (BPD),
- _head circumference_ (HC),
- _abdominal circumference_ (AC),
- and _femur length_ (FL)

on the estimated fetal weight (EFW) of various formulas.

The method involves calculating the Sobol' sensitivity indices of the parameters of some formula. The Sobol' method requires a lower and upper bound for the parameters, which is assumed to be the 10th and 90th percentile of the parameters taken from the datasets of various studies.

A list of the formulas and the studies this packages exports can be seen in the complimentary paper of this package [[1]](#1).

The package exports the ``Formula`` struct, which is defined as

```julia
struct Formula
    func::Function
    parameters::Vector{String}
    paper::String
end
```

For example, by defining the struct
```julia
hadlockIV = Formula(
    x-> (10^(1.3596 + 0.00061*x[1]*x[2] + 0.0424*x[2] + 0.174*x[3] + 0.0064*x[4] - 0.00386*x[2]*x[3])),
        ["BPD", "AC", "FL", "HC"],
        "Hadlock IV (1985)"
        )
```

one can define the formula $10^{1.3596+0.00061\left(\text{BPD}\right)\left(\text{AC}\right)+0.424\left(\text{AC}\right)+0.174\left(\text{FL}\right)+0.0064\left(\text{HC}\right)-0.00386\left(\text{AC}\right)\left(\text{FL}\right)}$ from [[2]](#2).

Then, for computing the Sobol' indices of ```hadlockIV``` for some datasets, for instance the dataset from [[3]](#3), which is included in [data.xlsx](DopEFW/data/raw/data.xlsx) in the sheet called ```"papageorghiou2014"```, you can use the function:
```julia
simulation(hadlockIV, "papageorghiou2014") 
```
which will return a DataFrame with the indices.

If you want to add a new dataset to the list, you'll have to add it as a newsheet in [data](DopEFW/data/raw/data.xlsx), and then running the function
```julia
using DrWatson
using DopEFW
using DataFrames, CSV

df = read_excel_sheets(datadir("raw", "data.xlsx"))
CSV.write(datadir("pro", "data.csv"), df)
```
to add the new dataset in the processed [data.csv](DopEFW/data/pro/data.csv)

## References
<a id="1">[1]</a> 
Bitsouni V, Gialelis N, Tsilidis V 2024 ‘Partial dependence of ultrasonically estimated fetal weight on individual biometric variables’ medRxiv [doi:10.1101/2024.09.17.24313697](https://doi.org/10.1101/2024.09.17.24313697)

<a id="2">[2]</a> 
Hadlock FP, R Harrist, RS Sharman, RL Deter, & SK Park 1985 ‘Estimation of fetal weight with the use of head, body, and femur measurements—a prospective study’ American Journal of Obstetrics & Gynecology 151(3):333–337

<a id="3">[3]</a> 
Papageorghiou AT, EO Ohuma, DG Altman, T Todros, LC Ismail, A Lambert, YA Jaffer, E Bertino, MG Gravett, M Purwar, JA Noble, R Pang, CG Victora, FC Barros, M Carvalho, LJ Salomon, ZA Bhutta, SH Kennedy, & J Villar 2014 ‘International standards for fetal growth based on serial ultrasound measurements: The Fetal Growth Longitudinal Study of the INTERGROWTH-21st Project’ The Lancet 384(9946):869–879 [doi:10.1016/S0140-6736(14)61490-2](https://doi.org/10.1016/S0140-6736(14)61490-2)