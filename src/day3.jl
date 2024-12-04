function remove_errors_and_eval(expression::String)::Int
    mul_regex = r"mul\((\d+),(\d+)\)"
    ans = 0
    for m in eachmatch(mul_regex, expression)
        ans += prod(parse.(Int, m.captures))
    end
    return ans
end

function remove_errors_do_dont_and_eval(expression::String, initial_activation::Bool=true)::Tuple{Int, Bool}
    active::Bool = initial_activation
    do_dont_mul_regex = r"(do\(\)|mul\((\d+),(\d+)\)|don't\(\))"
    ans = 0
    for m in eachmatch(do_dont_mul_regex, expression)
        if m.match == "don't()"
            active = false
        elseif m.match == "do()"
            active = true
        else
            if active
                ans += prod(parse.(Int, m.captures[2:3]))
            end
        end
    end
    return ans, active
end

function part_one(filename::String)
    ans = 0
    open(filename, "r") do f
        for line in eachline(f)
            ans += remove_errors_and_eval(line)
        end
    end
    return ans
end

function part_two(filename::String)
    ans = 0
    activation::Bool = true
    open(filename, "r") do f
        for line in eachline(f)
            current_contribution, activation = remove_errors_do_dont_and_eval(line, activation)
            ans += current_contribution
        end
    end
    return ans
end


test_part_one = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
test_part_two = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

println("test part one: ", remove_errors_and_eval(test_part_one) == 161)
println("test part two: ", remove_errors_do_dont_and_eval(test_part_two) == 48)

println("part one: ", part_one("../data/day3.txt"))
println("part two: ", part_two("../data/day3.txt"))