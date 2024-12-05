using DataFramesMeta, XLSX

"""
    split_string(s::String) -> Tuple{String, String}

Splits a string into two parts at the first occurrence of a digit.

# Arguments
- `s::String`: The input string to be split.

# Returns
A tuple containing two strings:
- The first element is the substring before the first digit.
- The second element is the substring from the first digit to the end of the string. If no digit is found, the second element will be an empty string.

# Example
```julia
result = split_string("Hello123World")
println(result)  # Output: ("Hello", "123World")
"""
function split_string(s::String)
    idx = findfirst(isdigit, s)  # Find the first occurrence of a digit
    if isnothing(idx)
        # If there is no digit, return the whole string as the first part and an empty second part
        return (s, "")
    else
        # Split the string at the first occurrence of a digit
        return (s[1:idx-1], s[idx:end])
    end
end

"""
    read_excel_sheets(file_path::String) -> DataFrame

Reads all sheets from an Excel file and combines them into a single DataFrame.

# Arguments
- `file_path::String`: The path to the Excel file from which to read the sheets.

# Returns
A `DataFrame` containing the combined data from all sheets in the specified Excel file. Each sheet's data is transformed and includes an additional column indicating the sheet name.
"""
function read_excel_sheets(file_path::String)

    xf = XLSX.readxlsx(file_path)

    sheet_names = XLSX.sheetnames(xf)
    dataframes = DataFrame[]
    
    for sheet_name in sheet_names
        sheet_df = DataFrame(XLSX.readtable(file_path, sheet_name; infer_eltypes=true))

       cdf = @chain sheet_df begin
           stack()
           transform(:variable => ByRow(x -> split_string(x)) => [:parameter, :percentile])
           select(Not(:variable))
       end
       cdf[:, :paper] .= sheet_name

        push!(dataframes, cdf)
    end
    
    combined_df = vcat(dataframes..., cols = :union)
    return combined_df
end

"""
    get_sheet_names(file_path::String) -> Vector{String}

Retrieves the names of all sheets in an Excel file.

# Arguments
- `file_path::String`: The path to the Excel file from which to read the sheet names.

# Returns
A vector of strings containing the names of the sheets in the specified Excel file.

# Example
```julia
sheet_names = get_sheet_names("example.xlsx")
println(sheet_names)  # Output: ["Sheet1", "Sheet2", "Data", ...]
"""
function get_sheet_names(file_path::String)
    xf = XLSX.readxlsx(file_path)
    sheet_names = XLSX.sheetnames(xf)

    return sheet_names
end