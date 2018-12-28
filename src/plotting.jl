using DelimitedFiles

export export_table

"Will copy matrix `M` to clipboard in a format which can be pasted into Apple Numbers"
function export_table(M)
    io = IOBuffer()
    writedlm(io, M, ',')
    s = String(take!(io))
    clipboard(s)
end