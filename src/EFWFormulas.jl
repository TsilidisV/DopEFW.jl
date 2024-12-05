struct Formula
    func::Function
    parameters::Vector{String}
    paper::String
end

function Base.show(io::IO, formula::Formula)
    print(io, formula.paper)
end

function Base.:(==)(x::Formula, y::Formula)
    return x.func == y.func && x.parameters == y.parameters && x.paper == y.paper
end

combs = Formula(x->(0.23718*x[1]^2 * x[2] + 0.03312*x[3]^3), ["AC", "FL", "HC"], "Combs (1993)")
ferrero = Formula(x-> (10^(0.77125 + 0.13244*x[1] - 0.12996*x[2] - 1.73588*(x[1]^2)/1000 + 3.09212*x[1]*x[2]/1000 + 2.18984*x[2]/x[1])), ["AC", "FL"], "Ferrero (1994)")
hadlock = Formula(x-> (10^(1.1134 + 0.1694*x[1] + 0.05845*x[2] + 0.007365*x[1]^2 - 0.000604*x[2]^2 + 0.000595*x[1]*x[2])), ["BPD", "AC"], "Hadlock (1984)")
hadlockI = Formula(x-> (10^(1.304 + 0.05281*x[1] + 0.1938*x[2] - 0.004*x[1]*x[2])), ["AC", "FL"], "Hadlock I (1985)")
hadlockII = Formula(x-> (10^(1.335 - 0.0034*x[2]*x[3] + 0.0316*x[1] + 0.0457*x[2] + 0.1623*x[3])), ["BPD", "AC", "FL"], "Hadlock II (1985)")
hadlockIII = Formula(x-> (10^(1.326 - 0.00326*x[1]*x[2] + 0.0107*x[3] + 0.0438*x[1] + 0.158*x[2])), ["AC", "FL", "HC"], "Hadlock III (1985)")
hadlockIV = Formula(x-> (10^(1.3596 + 0.00061*x[1]*x[2] + 0.0424*x[2] + 0.174*x[3] + 0.0064*x[4] - 0.00386*x[2]*x[3])), ["BPD", "AC", "FL", "HC"], "Hadlock IV (1985)")
halaska = Formula(x-> (10^(0.64041*x[1] - 0.03257*x[1]^2 + 0.00154*x[2]*x[3])), ["BPD", "AC", "FL"], "Halaska (2006)")
hsieh = Formula(x-> (10^(2.1315 + 0.0056541*x[1]*x[2] - 0.00015515*x[1]*x[2]^2 + 0.000019782*x[2]^3 + 0.052594*x[1])), ["BPD", "AC"], "Hsieh (1987)")
intergrowth17 = Formula(x-> (exp(5.084820 - 54.06633 * (x[1]/100)^3 - 95.80076 * log(x[1]/100) * (x[1]/100)^3 + 3.136370 * x[2] / 100)), ["AC", "HC"], "INTERGROWTH-21 (2017)")
jordaanI = Formula(x-> (10^(-1.1683 + 0.095*x[1] + 0.0377*x[2] - 0.0015*x[1]*x[2])), ["BPD", "AC"], "Jordaan I (1983)")
jordaanII = Formula(x-> (10^(0.9119 + 0.0824*x[1] + 0.0488*x[2] - 0.001599*x[1]*x[2])), ["AC", "HC"], "Jordaan II (1983)")
merz = Formula(x-> (-3200.40479 + 157.07186*x[2] + 15.90391*x[1]^2), ["BPD", "AC"], "Merz (1988)")
ott = Formula(x-> (10^(-2.0661 + 0.04355*x[3] + 0.05394*x[1] - 0.0008582*x[1]*x[3] + 1.2594*(x[2]/x[1]) )), ["AC", "FL", "HC"], "Ott (1986)")
roberts = Formula(x-> (10^(1.6758 + 0.01707*x[2] + 0.042478*x[1] + 0.05216*x[3] + 0.01604*x[4])), ["BPD", "AC", "FL", "HC"], "Roberts (1985)")
schild = Formula(x-> (5381.193 + 150.324 * x[3] + 2.069 * x[2]^3 + 0.0232 * x[1]^3 - 6235.478 * log10(x[3])), ["AC", "FL", "HC"], "Schild (2004)")
shepardI = Formula(x-> (10^(-1.599 + 0.144*x[1] + 0.032*x[2] - 0.000111*x[2]*x[1]^2)), ["BPD", "AC"], "Shepard I (1982)")
shepardII = Formula(x-> (10^(-1.7492 + 0.166*x[1] + 0.046*x[2] - 0.002646*x[1]*x[2])), ["BPD", "AC"], "Shepard II (1982)")
siemer = Formula(x-> (-5948.336 + 2101.261 * log(x[2]) + 15.613 * x[3]^2 + 0.577 * x[1]^3), ["BPD", "AC", "FL"], "Siemer (2007)")
thurnau = Formula(x-> (9.337*x[1]*x[2] - 229), ["BPD", "AC"], "Thurnau (1983)")
vintzileosI = Formula(x-> (10^(1.879 + 0.084*x[1] + 0.026*x[2])), ["BPD", "AC"], "Vintzileos I (1987)")
vintzileosII  = Formula(x-> (10^(2.082 + 0.004 * x[3] * x[2] + 0.0018 * x[1] - 0.00000001509 * (x[3] * x[2])^3)), ["AC", "FL", "HC"], "Vintzileos II (1987)")
warsof1977 = Formula(x-> (10^(-1.599 + 0.144*x[1] + 0.032*x[2] - 0.000111*x[2]*x[1]^2)), ["BPD", "AC"], "Warsof (1977)")
warsof1986 = Formula(x-> (exp(2.792 + 0.108*x[2] + 0.0000336*x[1]^2 - 0.00027*x[1]x[2])), ["AC", "FL"], "Warsof (1986)")
weinerI  = Formula(x-> (10^(1.6961 + 0.02253*x[3] + 0.01645*x[1] + 0.06439*x[2])), ["AC", "FL", "HC"], "Weiner I (1985)")
weinerII  = Formula(x-> (10^(1.6575 + 0.04035*x[2] + 0.01285*x[1])), ["AC", "HC"], "Weiner II (1985)")
woo  = Formula(x-> (1.4*x[1]*x[2]*x[3] - 200), ["BPD", "AC", "FL"], "Woo (1986)")
wooI  = Formula(x-> (10^(1.54 + 0.15*x[1] + 0.00111*x[2]^2 - 0.0000764*x[1]*x[2]^2 + 0.05*x[3] - 0.000992*x[2]*x[3])), ["BPD", "AC", "FL"], "Woo I (1985)")
wooII  = Formula(x-> (10^(1.14 + 0.16*x[1] + 0.05*x[2] - 2.8*x[1]*x[2]/1000 + 0.04*x[3] - 4.9*x[2]*x[3]/10000)), ["BPD", "AC", "FL"], "Woo II (1985)")
wooIII  = Formula(x-> (10^(1.13 + 0.18*x[1] + 0.05*x[2] - 3.35*x[1]*x[2]/1000)), ["BPD", "AC"], "Woo III (1985)")
wooIV  = Formula(x-> (10^(1.63 + 0.16*x[1] + 0.00111*x[2]^2 - 0.0000859*x[1]*x[2]^2)), ["BPD", "AC"], "Woo IV (1985)")
wooV  = Formula(x-> (10^(0.59 + 0.08*x[1] + 0.28*x[2] - 0.00716*x[1]*x[2])), ["AC", "FL"], "Woo V (1985)")

formula_vector = [combs, ferrero, hadlockI, hadlockII, hadlockIII, hadlockIV, halaska, hsieh, intergrowth17, jordaanI, jordaanII, 
merz, ott, roberts, schild, shepardI, shepardII, siemer, thurnau, vintzileosI, warsof1977, weinerI, weinerII, woo, wooI, wooII, wooIII, wooIV, wooV]

