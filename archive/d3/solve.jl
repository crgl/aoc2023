function display_input(lines, part_nums, part_of)
    digits = "0123456789"
    for (i, line) in enumerate(lines)
        for (j, c) in enumerate(line)
            if c in digits
                symbol_adj = part_nums[part_of[(i, j)]][2]
                if symbol_adj
                    printstyled(c, color=:blue)
                else
                    printstyled(c, color=:red)
                end
            elseif c == '.'
                print(c)
            else
                printstyled(c, color=:green)
            end
        end
        println()
    end
end

function neighbors_and_self(i, j, ht, wd)
    [(y,x) for (y,x) in Iterators.product(i-1:i+1, j-1:j+1) if y >= 1 && y <= ht && x >= 1 && x <= wd]
end

function parse_input(input_fname)
    digits = "0123456789"
    not_symbol = digits * "."
    part_nums = []
    lines = readlines(input_fname)
    @assert all(length.(lines) .== length(lines[1])) "Input is not a rectangle"
    height = length(lines)
    width = length(lines[1])
    part_of = Dict()
    part_num = 0
    symbol_adj = false
    for (i, line) in enumerate(lines)
        for (j, c) in enumerate(line)
            if c in digits
                part_num *= 10
                part_num += parse(UInt, c)
                to_check = neighbors_and_self(i, j, height, width)
                for (i2, j2) in to_check
                    symbol_adj |= !(lines[i2][j2] in not_symbol)
                end
                part_of[(i, j)] = length(part_nums) + 1
            elseif part_num != 0
                push!(part_nums, (part_num, symbol_adj))
                part_num = 0
                symbol_adj = false
            end
        end
        if part_num != 0
            push!(part_nums, (part_num, symbol_adj))
            part_num = 0
            symbol_adj = false
        end
    end
    if part_num != 0
        push!(part_nums, (part_num, symbol_adj))
        part_num = 0
        symbol_adj = false
    end
    gear_sets = Dict()
    for (i, line) in enumerate(lines)
        for (j, c) in enumerate(line)
            if c == '*'
                gear_sets[(i, j)] = Set()
                to_check = neighbors_and_self(i, j, height, width)
                for (i2, j2) in to_check
                    if lines[i2][j2] in digits
                        push!(gear_sets[(i, j)], part_of[(i2, j2)])
                    end
                end
            end
        end
    end
    # display_input(lines, part_nums, part_of)
    (part_nums, gear_sets)
end

function p1(part_nums)
    part_sum = 0
    for (part_num, valid) in part_nums
        if valid
            part_sum += part_num
        end
    end
    println("P1: ", part_sum)
end

function p2(part_nums, gear_sets)
    gear_sum = 0
    for (gear_loc, gear_set) in gear_sets
        if length(gear_set) == 2
            gear_sum += prod((part_nums[idx][1] for idx in gear_set))
        end
    end
    println("P2: ", gear_sum)
end

part_nums, gear_sets = parse_input(ARGS[1])
p1(part_nums)
p2(part_nums, gear_sets)
