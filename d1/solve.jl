function parse_input(input_fname)
    return readlines(input_fname)
end

function p1(data)
    calibration_sum = 0
    for s in data
        m = match(r"([0-9]).*([0-9])", s)
        if isnothing(m)
            m = match(r"([0-9])", s)
        end
        d1 = parse(UInt, m.captures[begin])
        d2 = parse(UInt, m.captures[end])
        calibration_sum += 10 * d1 + d2
    end
    println("P1: ", calibration_sum)
end

function word_to_num(s)
    mapper = Dict([("zero", 0), ("one", 1), ("two", 2), ("three", 3),
    ("four", 4), ("five", 5), ("six", 6), ("seven", 7), ("eight", 8),
    ("nine", 9)])
    output = tryparse(UInt, s)
    if isnothing(output)
        output = mapper[s]
    end
    return output
end

function p2(data)
    calibration_sum = 0
    for s in data
        digit_match = r"([0-9]|zero|one|two|three|four|five|six|seven|eight|nine)"
        m1 = match(digit_match, s)
        m2 = match(r".*" * digit_match, s)
        d1 = word_to_num(m1.captures[begin])
        d2 = word_to_num(m2.captures[begin])
        calibration_sum += 10 * d1 + d2
    end
    println("P2: ", calibration_sum)
end

data = parse_input(ARGS[1])
p1(data)
p2(data)
