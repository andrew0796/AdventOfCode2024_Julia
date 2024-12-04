function issafe(report::Vector{Int})::Bool
    if issorted(report) || issorted(report, rev=true)
        return !any(x -> x < 1 || x > 3, abs.(report - circshift(report, -1))[1:end-1])
    else
        return false
    end
end

function issafe_one_error(report::Vector{Int})::Bool
    if issafe(report)
        return true
    end
    for i=1:length(report)
        temp_report = copy(report)
        deleteat!(temp_report, i)
        if issafe(temp_report)
            return true
        end
    end
    return false
end

function count_safe(filename::String)
    safe = 0
    open(filename, "r") do f
        for line in eachline(f)
            report = parse.(Int, split(line))
            if issafe(report)
                safe += 1
            end
        end
    end
    return safe
end

function count_safe_one_error(filename::String)
    safe = 0
    open(filename, "r") do f
        for line in eachline(f)
            report = parse.(Int, split(line))
            if issafe_one_error(report)
                safe += 1
            end
        end
    end
    return safe
end

println("test part one: ", count_safe("../data/test2.txt")==2)
println("part one: ", count_safe("../data/day2.txt"))

println("test part two: ", count_safe_one_error("../data/test2.txt")==4)
println("part two: ", count_safe_one_error("../data/day2.txt"))