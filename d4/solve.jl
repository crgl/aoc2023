function parse_input(input_fname)
    output = []
    for line in readlines(input_fname)
        _card_name, card_nums = split(line, ":")
        winning_str, mine_str = split(card_nums, "|")
        winning = parse.(UInt, split(winning_str))
        mine = parse.(UInt, split(mine_str))
        push!(output, (winning, mine))
    end
    output
end

function p1(cards)
    point_sum = 0
    for (winning, mine) in cards
        matches = length(Set(winning) ∩ Set(mine))
        if matches > 0
            point_sum += 2^(matches - 1)
        end
    end
    println("P1: ", point_sum)
end

function p2(cards)
    num_extra = 0
    total_cards::UInt = 0
    duplicate_counting = []
    for (winning, mine) in cards
        num_cards = 1 + num_extra
        matches = length(Set(winning) ∩ Set(mine))
        extra_zeros = matches - length(duplicate_counting)
        if extra_zeros > 0
            append!(duplicate_counting, zeros(extra_zeros))
        end
        for i in 1:matches
            duplicate_counting[i] += num_cards
        end
        total_cards += num_cards
        if !isempty(duplicate_counting)
            num_extra = popfirst!(duplicate_counting)
        else
            num_extra = 0
        end
    end
    println("P2: ", total_cards)
end

cards = parse_input(ARGS[1])
p1(cards)
p2(cards)
