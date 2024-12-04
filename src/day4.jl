function read_data(filename::String)
    data = String[]
    open(filename, "r") do f
        for line in eachline(f)
            push!(data, line)
        end
    end
    return data
end

function find_christmas(data::Vector{String})
    width = length(data[1])
    height = length(data)
    goal = "XMAS"
    count = 0
    for (i, line) in enumerate(data)
        for j in findall('X', line)
            # check forward horizontal
            if j <= width-length(goal)+1 && line[j:j-1+length(goal)] == goal
                count += 1
            end
            
            # check backward horizontal
            if j >= length(goal) && line[j:-1:j+1-length(goal)] == goal
                count += 1
            end

            # check upper vertical
            if i >= length(goal) && *([data[i+1-k][j] for k=1:length(goal)]...) == goal
                count += 1
            end

            # check lower vertical
            if i <= height-length(goal)+1 && *([data[i-1+k][j] for k=1:length(goal)]...) == goal
                count += 1
            end

            # check upper right diagonal
            if i >= length(goal) && j <= width-length(goal)+1
                if *([data[i+1-k][j-1+k] for k=1:length(goal)]...) == goal
                    count += 1
                end
            end

            # check lower right diagonal
            if i <= height-length(goal)+1 && j <= width-length(goal)+1
                if *([data[i-1+k][j-1+k] for k=1:length(goal)]...) == goal
                    count += 1
                end
            end

            # check upper left diagonal
            if i >= length(goal) && j >= length(goal)
                if *([data[i+1-k][j+1-k] for k=1:length(goal)]...) == goal
                    count += 1
                end
            end

            # check lower left diagonal
            if i <= height-length(goal)+1 && j >= length(goal)
                if *([data[i-1+k][j+1-k] for k=1:length(goal)]...) == goal
                    count += 1
                end
            end
        end
    end
    return count
end

function find_christmas_cross(data::Vector{String})
    width = length(data[1])
    height = length(data)
    goal = "MAS"
    count = 0
    matching(word::String)::Bool = word == goal || reverse(word) == goal
    for (i, line) in enumerate(data)
        if i == 1 || i == height
            continue
        end
        for j in findall('A', line)
            if j == 1 || j == width
                continue
            end

            if matching(*([data[i-1+k][j-1+k] for k=0:length(goal)-1]...)) && matching(*([data[i+1-k][j-1+k] for k=0:length(goal)-1]...))
                count += 1
            end
        end
    end
    return count
end

println("test part one: ", find_christmas(read_data("../data/test4.txt"))==18)
println("test part one: ", find_christmas_cross(read_data("../data/test4.txt"))==9)

println("part one: ", find_christmas(read_data("../data/day4.txt")))
println("part one: ", find_christmas_cross(read_data("../data/day4.txt")))