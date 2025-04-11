"""
    Dict containing the colors for each parameter.
"""
param_color = Dict(
    "BPD"    => "#F32EA1",
    "AC"     => "#0BD976",
    "FL"     => "#FFD92E",
    "HC"     => "#8630BF",
)

"""
    Dict containing the markers for each parameter.
"""
param_marker = Dict(
    "BPD"    => :star5,
    "AC"     => :circle,
    "FL"     => :xcross,
    "HC"     => :utriangle,
)

"""
    numtogrid(i::Int, numberofcolumns::Int)

Convert a linear index to grid coordinates (row and column) based on a specified number of columns, assuming row-wise filling.

# Arguments
- `i::Int`: The 1-based linear index to convert.
- `numberofcolumns::Int`: The number of columns in the grid layout.

# Returns
- A `Dict` with keys `:row` and `:col` indicating the grid position. Rows and columns are 1-based.

# Description
This function calculates the grid position of the `i`-th element in a grid with `numberofcolumns` columns, where elements are arranged left-to-right, top-to-bottom. The row is computed as the ceiling of `i / numberofcolumns`, and the column is derived from the remainder of the division, adjusted for 1-based indexing.

# Examples
```jldoctest
julia> numtogrid(5, 2)
Dict{Symbol, Int64} with 2 entries:
  :row => 3
  :col => 1

julia> numtogrid(3, 2)
Dict{Symbol, Int64} with 2 entries:
  :row => 2
  :col => 1
```

"""
function numtogrid(i::Int, numberofcolumns::Int)
    row = divrem(i+numberofcolumns-1, numberofcolumns)[1] 
    col = (i+numberofcolumns-1)%numberofcolumns + 1
    return Dict(:row => row, :col => col)
end


"""
    metadata_getter(file_path::String)

Read medical fetal weight estimation formulas from an Excel file, mapping formula names to their LaTeX representations.

# Arguments
- `file_path::String`: Path to the Excel (.xlsx) file containing formula metadata.

# Returns
- `Dict{String, String}`: A dictionary where:
  - **Keys** are formula names/identifiers (e.g., "Hadlock (1984)")
  - **Values** are LaTeX-formatted formulas with measurement placeholders:
    - `(AC)`: Abdominal Circumference
    - `(FL)`: Femur Length
    - `(HC)`: Head Circumference
    - `(BPD)`: Biparietal Diameter

# Example
For an Excel sheet containing:
| A              | B                                      |
|----------------|----------------------------------------|
| Hadlock (1984) | 10^{1.1134+0.05845 (AC) -0.000604 (AC)^2... |

```julia
julia> metadata_getter("metadata.xlsx")["Hadlock (1984)"]
"10^{1.1134+0.05845 (AC) -0.000604 (AC)^2+0.007365 (BPD)^2+0.000595 (BPD) (AC) +0.1694 (BPD) }"
```
"""
function metadata_getter(file_path::String)
    metadata_dict = Dict()
    XLSX.openxlsx(file_path) do xf
        sheet = xf[1]  # Access the first sheet

        # Read the first two columns into vectors
        col1 = sheet[:, 1]  # First column containing the names of the formulas
        col2 = sheet[:, 2]  # Second column containing the formulas in LaTeX

        # Populate the dictionary
        metadata_dict = Dict(col1[i] => col2[i] for i in 1:length(col1))
    end

    return metadata_dict
end