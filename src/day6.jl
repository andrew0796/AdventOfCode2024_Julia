using Folds

function readdata(datafile::String)::Matrix{Char}
    data = String[]
    open(datafile, "r") do f
        for line in eachline(f)
            push!(data, line)
        end
    end

    data_matrix = Matrix{Char}(undef, length(data), length(data[1]))
    for (i, line) in enumerate(data)
        for (j, c) in enumerate(line)
            data_matrix[i, j] = c
        end
    end

    return data_matrix
end

const next_direction = Dict{Char, Char}('^'=>'>', '>'=>'v', 'v'=>'<', '<'=>'^')
const next_position  = Dict{Char, CartesianIndex}('^'=>CartesianIndex(-1,0),
                                                  '>'=>CartesianIndex(0,1),
                                                  'v'=>CartesianIndex(1,0),
                                                  '<'=>CartesianIndex(0,-1))

is_direction(c::Char) = c in ['^', '>', 'v', '<']

function is_exiting(current_position::CartesianIndex, current_direction::Char, dimensions::NTuple{2, Int})::Bool
    if 1 < current_position[1] < dimensions[1] && 1 < current_position[2] < dimensions[2]
        return false
    end
    if current_position[1] == 1 && current_direction == '^'
        return true
    elseif current_position[1] == dimensions[1] && current_direction == 'v'
        return true
    elseif current_position[2] == 1 && current_direction == '<'
        return true
    elseif current_position[2] == dimensions[2] && current_direction == '>'
        return true
    end
    return false
end

function explore_map!(data::Matrix{Char})::Bool
    """ have the security guard walk around until either they end up at their starting position or they exit, return a Boolean indicating if the guard left """
    initial_position = findfirst(is_direction, data)
    initial_direction = data[initial_position]
    
    current_position = initial_position
    current_direction = initial_direction

    visited_directions = Dict{CartesianIndex, Vector{Char}}(current_position => [initial_direction])
    while !is_exiting(current_position, current_direction, size(data))
        next = current_position + next_position[current_direction]
        if data[next] == '#'
            current_direction = next_direction[current_direction]
        else
            data[current_position] = 'X'
            current_position = next
        end

        if current_position in keys(visited_directions)
            if current_direction ∉ visited_directions[current_position]
                push!(visited_directions[current_position], current_direction)
            else
                break
            end
        else
            visited_directions[current_position] = Char[current_direction]
        end
    end
    data[current_position] = 'X'
    return is_exiting(current_position, current_direction, size(data))
end

function part_one(data::Matrix{Char})::Int
    copy_data = copy(data)
    
    explore_map!(copy_data)

    return count(x -> x == 'X', copy_data)
end


function part_two(data::Matrix{Char})::Int
    # first, sites that aren't visited cannot be locations for obstacles, neither can sites that already have obstables
    copy_data = copy(data)
    explore_map!(copy_data)
    sites_to_skip = findall(x -> x == '#' || x == '.', copy_data)
    push!(sites_to_skip, findfirst(is_direction, data))

    count = 0

    function check_site(site::CartesianIndex)
        if site in sites_to_skip
            return 0
        end
        c = copy(data)
        c[site] = '#'
        if ! explore_map!(c)
            return 1
        end
        return 0
    end

    # use multithreading!
    return Folds.sum(check_site(site) for site in eachindex(IndexCartesian(), data))
end
    


test_data = readdata("data/test6.txt")

println("test part one: ", part_one(test_data)==41)
println("test part two: ", part_two(test_data)==6)

@time begin
    data = readdata("data/day6.txt")
    println("part one: ", part_one(data))
    println("part two: ", part_two(data))
end

