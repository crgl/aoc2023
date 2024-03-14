function parse_input(input_fname)
    outcomes = Dict()
    for line in readlines(input_fname)
        game_id_str, games_string = split(line, ":")
        game_id = parse(UInt, split(game_id_str)[end])
        games = split(games_string, ";")
        outcomes[game_id] = []
        for game in games
            cube_sets = split(game, ",")
            outcome = Dict()
            for cube_set in cube_sets
                cube_count_str, cube_color = split(cube_set)
                outcome[cube_color] = parse(UInt, cube_count_str)
            end
            push!(outcomes[game_id], outcome)
        end
    end
    outcomes
end

function p1(data)
    max_counts = Dict([("red", 12), ("green", 13), ("blue", 14)])
    id_sum = 0
    for (game_id, outcomes) in pairs(data)
        valid = true
        for outcome in outcomes
            for (color, max_count) in max_counts
                if haskey(outcome, color) && outcome[color] > max_count
                    valid = false
                end
            end
        end
        if valid
            id_sum += game_id
        end
    end
    println("P1: ", id_sum)
end

function p2(data)
    power_sum = 0
    for (_game_id, outcomes) in data
        min_counts = Dict([("red", 0), ("green", 0), ("blue", 0)])
        for outcome in outcomes
            for (color, count) in outcome
                min_counts[color] = max(min_counts[color], count)
            end
        end
        power_sum += prod(values(min_counts))
    end
    println("P2: ", power_sum)
end

data = parse_input(ARGS[1])
p1(data)
p2(data)
