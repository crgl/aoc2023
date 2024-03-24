function parse_input(input_fname)
    seeds = []
    mappers = []
    for (i, line) in enumerate(readlines(input_fname))
        if i == 1
            append!(seeds, parse.(UInt, split(split(line, ':')[2])))
        else
            if occursin("map", line)
                push!(mappers, [])
            elseif length(line) > 3
                push!(mappers[end], parse.(UInt, split(line)))
            end
        end
    end
    for mapper in mappers
        sort!(mapper, by=tup->tup[2])
    end
    seeds, mappers
end

function p1(seeds, mappers)
    locations = []
    for seed in seeds
        val = seed
        for mapper in mappers
            for (dst, src, len) in mapper
                if val >= src && val < src + len
                    val = dst + val - src
                    break
                end
            end
        end
        push!(locations, val)
    end
    sort!(locations)
    println("P1:", locations[begin])
end

function p2(seeds, mappers)
    seed_ranges = []
    for (seed1, range_size) in zip(seeds[1:2:end], seeds[2:2:end])
        push!(seed_ranges, (seed1, seed1 + range_size - 1))
    end
    sort!(seed_ranges)
    old_ranges = seed_ranges
    for mapper in mappers
        new_ranges = []
        for (lend, rend) in old_ranges
            for (dst, src, len) in mapper
                if src <= rend && src + len > lend
                    if src <= lend
                        if src + len > rend
                            push!(new_ranges, (lend - src + dst, rend - src + dst))
                            break
                        else
                            push!(new_ranges, (lend - src + dst, dst + len - 1))
                            lend = src + len
                        end
                    else
                        push!(new_ranges, (lend, src - 1))
                        lend = src
                        if src + len > rend
                            push!(new_ranges, (lend - src + dst, rend - src + dst))
                            break
                        else
                            push!(new_ranges, (lend - src + dst, dst + len - 1))
                            lend = src + len
                        end
                    end
                end
            end
        end
        sort!(new_ranges)
        old_ranges = new_ranges
    end
    println("P2:", old_ranges[1][1])
end

(seeds, mappers) = parse_input(ARGS[1])
p1(seeds, mappers)
p2(seeds, mappers)