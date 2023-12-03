using DelimitedFiles
using Markdown

md"# First part"
##
function processLine(line)
    numbers_in_line = [tryparse(Int,string(char)) for char in line]
    numbers_in_line[numbers_in_line .!= nothing]
end
function processVector(vector)
    parse(Int,join(string.(vector[[1,end]])))
end
fromLineToValue(line) =  processVector(processLine(line))

# line = "treb7uchet"
# vector = processLine(line)
# processVector(vector)
# fromLineToValue("a12c3d4e55f")
# fromLineToValue("treb7uchet")

# inputMatrix = readdlm("example1")
# inputMatrix = readdlm("input")

##
function answer1(input)
    inputMatrix = readdlm("input")
    total = 0
    for row in inputMatrix
        total += fromLineToValue(string(row))
    end
    total
end
@show answer1("input")
#######################
##

md"# Second part"

words2numbers = Dict(
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9,
    )
words = collect(keys(words2numbers))
words2wordsLength = Dict(words .=> length.(words))

function processChar(i, line, words2wordsLength, words2numbers, words)
    char = line[i]
    numberParsed = tryparse(Int,string(char))
    if numberParsed !== nothing
        return numberParsed
    end
    for word in words
        if length(line) - i + 1 >= words2wordsLength[word]
            # println(line,",",word,",",i,",",words2wordsLength[word],",",i+words2wordsLength[word]-1)
            relevantSection = line[i:i+words2wordsLength[word]-1]
            if relevantSection == word
                return words2numbers[word]
            end
        end
    end
end

##
function processLine2(line, words2wordsLength, words2numbers, words)
    numbers_in_line = [processChar(i,line, words2wordsLength, words2numbers, words) for i in 1:length(line)]
    numbers_in_line[numbers_in_line .!= nothing]
end

fromLineToValue2(line, words2wordsLength, words2numbers, words) =  processVector(processLine2(line,words2wordsLength, words2numbers, words))

function answer2(input, words2numbers)
    inputMatrix=readdlm(input)
    words = collect(keys(words2numbers))
    words2wordsLength = Dict(words .=> length.(words))
    total = 0
    for row in inputMatrix
        total += fromLineToValue2(string(row), words2wordsLength, words2numbers, words)
    end
    total
end


@show answer2("input",words2numbers)
md""