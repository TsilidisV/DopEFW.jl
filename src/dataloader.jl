using DataFramesMeta, XLSX

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

function get_sheet_names(file_path::String)
    xf = XLSX.readxlsx(file_path)
    sheet_names = XLSX.sheetnames(xf)

    return sheet_names
end