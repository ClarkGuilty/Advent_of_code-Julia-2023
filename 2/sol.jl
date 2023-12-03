using Markdown


println(md"# First part")
colors = ["green", "blue", "red"]
color2index = Dict(colors .=> 1:length(colors))

##
input = readlines("input")

splitSets(line) = split(split(line,':')[end],';')

splitCubes(set) = split.(split(set,','))

function processCubes(pair; colors = colors, color2index = color2index)
    cubes = zeros(Int, length(colors))
    if pair[2] ∈ colors
        cubes[color2index[pair[2]]] += parse(Int,pair[1])
    end
    cubes
end

processGame(set) = sum(processCubes.(splitCubes(set)))

function processLine(line)
    splitSets(line)
end

processAndSumCubes(cubes) = sum(processCubes.(cubes))

processLine(line) = processAndSumCubes.(splitCubes.(splitSets(line)))

getLineMaxima(processedLine) = reshape(collect(maximum(reduce(hcat,processedLine),dims=2)'),3)

lineToMaxima(line) = getLineMaxima(processLine(line))



target = zeros(Int,length(colors))
target[color2index["red"]] = 12
target[color2index["green"]] = 13
target[color2index["blue"]] = 14

isViable(matrix,target) = sum(matrix .<= target) == length(target)


function answer1(filename,target=target)
    input = readlines(filename)
    total = 0
    for (i,line) in enumerate(input)
        if isViable(lineToMaxima(line),target)
            total += i
        end
    end
    total
end
answer1("example1")
@show answer1("input")
##
md"# Second part"

function answer2(filename,target=target)
    input = readlines(filename)
    sum(prod.(lineToMaxima.(input)))
end

@show answer2("input")
md""