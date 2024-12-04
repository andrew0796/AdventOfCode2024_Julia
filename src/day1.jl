function compare_lists(l1::Vector{Int}, l2::Vector{Int})
    l1_sorted = sort(l1)
    l2_sorted = sort(l2)
    return sum(abs.(l1_sorted-l2_sorted))
end

function test_part_one()
    l1 = [3,4,2,1,3,3]
    l2 = [4,3,5,3,9,3]

    my_answer = compare_lists(l1, l2)
    correct_answer = 11

    return my_answer == correct_answer
end

function compare_lists_with_similarity(l1::Vector{Int}, l2::Vector{Int})
    similarity = 0
    for i in l1
        similarity += i*count(x -> x==i, l2)
    end
    return similarity
end

function test_part_two()
    l1 = [3,4,2,1,3,3]
    l2 = [4,3,5,3,9,3]

    my_answer = compare_lists_with_similarity(l1, l2)
    correct_answer = 31

    return my_answer == correct_answer
end

function read_data(filename::String="../data/day1.txt")
    l1 = Int[]
    l2 = Int[]
    open(filename, "r") do f
        for line in eachline(f)
            i1, i2 = parse.(Int, split(line))
            push!(l1, i1)
            push!(l2, i2)
        end
    end
    return l1, l2
end

println("test part one: ", test_part_one())
println("test part two: ", test_part_two())

l1, l2 = read_data()
println("part one: ", compare_lists(l1, l2))
println("part two: ", compare_lists_with_similarity(l1, l2))