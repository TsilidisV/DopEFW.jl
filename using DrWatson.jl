using DrWatson
quickactivate("F:\\Users\\Billy\\Documents\\Math\\Research\\2025_Sonographer\\DopEFW", "DopEFW")
using DopEFW

str = ""
for formula in formula_vector
    str *= """
    \\begin{figure}
    \\centering
    \\includegraphics[width=\\linewidth]{figures/paper=$(formula.paper).png}
    \\caption{Estimate of the mean of the first order Sobol' indices of $(formula.paper).}
    \\label{fig:$(formula.paper)}
    \\end{figure}
    
    \n
    """
end
clipboard(str)