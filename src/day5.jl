using Memoization

function read_data(filename::String)
    orderings = Vector{Int}[]
    updates = Vector{Int}[]
    open(filename, "r") do f
        for line in eachline(f)
            if occursin("|", line)
                # read rule
                push!(orderings, parse.(Int, split(line, '|')))
            elseif length(line) > 0
                # read updates
                push!(updates, parse.(Int, split(line, ',')))
            end
        end
    end

    return orderings, updates
end

function correctly_ordered(update::Vector{Vector{Int64}}, orderings::Vector{Vector{Int64}})::Bool
    for order in orderings
        first_ndx = findfirst(x -> x == order[1], update)
        second_ndx = findfirst(x -> x == order[2], update)
        if isnothing(first_ndx) || isnothing(second_ndx)
            continue
        elseif first_ndx > second_ndx
            return false
        end
    end
    return true
end

function generate_ordering_dict(orderings::Vector{Vector{Int}})::Dict{Int, Vector{Int}}
    result = Dict{Int, Vector{Int}}()
    for order in orderings
        if haskey(result, order[1])
            push!(result[order[1]], order[2])
        else
            result[order[1]] = [order[2]]
        end
    end
    return result
end

function isless_with_orderings(x::Int, y::Int, ordering_dict::Dict{Int, Vector{Int}})::Bool
    if !haskey(ordering_dict, x) && haskey(ordering_dict, y)
        return false
    elseif !haskey(ordering_dict, y) && haskey(ordering_dict, x)
        return true
    elseif !haskey(ordering_dict, x) && !haskey(ordering_dict, y)
        error("neither $x nor $y are in ordering_dict, can't order")
    end

    if y in ordering_dict[x]
        return true
    elseif x in ordering_dict[y]
        return false
    end

    for entry in ordering_dict[x]
        if isless_with_orderings(entry, y, ordering_dict)
            return true
        end
    end
    return false
end

function order_update!(update::Vector{Int}, ordering_dict::Dict{Int, Vector{Int}})
    sort!(update, lt=(x,y) -> isless_with_orderings(x,y,ordering_dict))
end
    

function part_one(updates::Vector{Vector{Int64}}, orderings::Vector{Vector{Int64}})::Int64
    ans = 0
    for update in updates
        if correctly_ordered(update, orderings)
            ans += update[cld(length(update),2)]
        end
    end
    return ans
end

function part_two(updates::Vector{Vector{Int64}}, orderings::Vector{Vector{Int64}})::Int64
    ans = 0
    ordering_dict = generate_ordering_dict(orderings)
    for update in updates
        if !correctly_ordered(update, orderings)
            order_update!(update, ordering_dict)
            ans += update[cld(length(update),2)]
        end
    end
    return ans
end

test_orderings, test_updates = read_data("data/test5.txt")
orderings, updates = read_data("data/day5.txt")

println("test part one: ", part_one(test_updates, test_orderings)==143)
println("test part two: ", part_two(test_updates, test_orderings)==123)

@time begin
    println("part one: ", part_one(updates, orderings))
    println("part two: ", part_two(updates, orderings))
end