using DelimitedFiles
using InteractiveUtils

export export_table, plot

"Will copy matrix `M` to clipboard in a format which can be pasted into Apple Numbers"
function export_table(M)
    io = IOBuffer()
    writedlm(io, M, ',')
    s = String(take!(io))
    clipboard(s)
end

function plot(f::Function, xs)
    ys = f.(xs)
    if eltype(ys) <: Tuple
        rows = length(ys)
        if rows > 0
            cols = length(ys[1])
            M = zeros((rows, cols + 1))
            M[:, 1] = xs
            for (i, tuple) in enumerate(ys)
                for (j, x) in enumerate(tuple)
                    M[i, j + 1] = x
                end
            end
            export_table(M)
            M
        else
            error("No rows")
        end 
    else
        M = hcat(xs, ys)
        export_table(M)
        M
    end
end

