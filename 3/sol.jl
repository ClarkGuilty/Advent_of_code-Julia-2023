using DelimitedFiles
using Markdown


md"# First part"


readInput(filename) = permutedims(reduce(hcat,collect.(readlines(filename)))) 
input = readInput("example1")

numberChars = Char.(convert.(Int32,collect(48:57)))
irrelevantChars = [numberChars... ,'.']

struct ListNumber
    initial_i::Int
    initial_j::Int
    final_i::Int
    value::Int
end
getValue(listNumber::ListNumber) = listNumber.value
function extractNumbers(array; numberChars = numberChars)
    digitsToSave = Char[]
    numbersSaved = ListNumber[]
    initial_i = 0
    for j in 1:size(array)[1]
        for i in 1:size(array)[2]
            if array[j,i] ∈ numberChars
                if length(digitsToSave) == 0
                    initial_i = i
                end
                push!(digitsToSave,array[j,i])
            else
                if length(digitsToSave) > 0
                    push!(numbersSaved,
                    ListNumber(initial_i,j,i-1, parse(Int,join(digitsToSave))))
                end
                digitsToSave = Char[]
            end
        end
        if length(digitsToSave) > 0
            push!(numbersSaved,
            ListNumber(initial_i,j,size(array)[1], parse(Int,join(digitsToSave))))
        end
        digitsToSave = []
    end
    numbersSaved
end
using BenchmarkTools

compareTuple(tuple1, tuple2, operation) = operation.(tuple1,tuple2)
isGoodTupleByOperation(tuple1, conditionTuple, operation) = all(compareTuple(tuple1,conditionTuple,operation))

function isGoodTuple(tuple1, sizes)
    prod([
        isGoodTupleByOperation(tuple1,(0,0),>),
        isGoodTupleByOperation(tuple1,sizes,<=)
    ])
end

function listAdjacentPositions(listNumber::ListNumber, sizes::Tuple{Int,Int} )
    adjacents = [
    [(listNumber.initial_j-1, i) for i in listNumber.initial_i-1:listNumber.final_i+1]
    [(listNumber.initial_j, listNumber.initial_i-1), (listNumber.initial_j, listNumber.final_i+1)]
    [(listNumber.initial_j+1, i) for i in listNumber.initial_i-1:listNumber.final_i+1]
    ]
    CartesianIndex.(adjacents[isGoodTuple.(adjacents,[sizes])])
end

function isPartNumber(listNumber::ListNumber, input; irrelevantChars)
    sizes = size(input)
    relevantPositions = listAdjacentPositions(listNumber,sizes)
    !all(in.(input[relevantPositions], [irrelevantChars]))
end


function answer1(filename; irrelevantChars=irrelevantChars)
    input = readInput(filename)
    extractedNumbers = extractNumbers(input)
    goodNumberIndexes = isPartNumber.(extractedNumbers, [input], irrelevantChars=irrelevantChars)
    sum(getValue.(extractedNumbers[goodNumberIndexes] ))
end

@show answer1("input")

md""
##############################################
##
md"# Second part"

filename = "example1"

const GEAR = '*'
struct ListGear
    j::Int
    i::Int
end
ListGear(index::CartesianIndex) = ListGear(index.I[1],index.I[2])
getPosition(listGear::ListGear) = CartesianIndex((listGear.j,listGear.i))

function listAdjacentPositions(listGear::ListGear, sizes::Tuple{Int,Int} )
    adjacents = [
    [(listGear.j-1, i) for i in listGear.i-1:listGear.i+1]
    [(listGear.j, listGear.i-1), (listGear.j, listGear.i+1)]
    [(listGear.j+1, i) for i in listGear.i-1:listGear.i+1]
    ]
    CartesianIndex.(adjacents[isGoodTuple.(adjacents,[sizes])])
end

isIn(coordinate::Tuple{Int,Int}, listNumber::ListNumber) =
    prod([
    coordinate[2] ∈ listNumber.initial_i:listNumber.final_i,
    coordinate[1] == listNumber.initial_j
])

function findAdjacentNumbers(gearPoint::CartesianIndex{2}, input, extractedNumbers)
    gearPointsToTest = listAdjacentPositions(ListGear(gearPoint), size(input))
    reduce(vcat,unique([extractedNumbers[isIn.([coordinate.I],extractedNumbers)] for coordinate in gearPointsToTest]))
end


function answer2(filename)
    input = readInput(filename)
    extractedNumbers = extractNumbers(input)
    gearPoints = findall(==(GEAR), input)
    total = 0
    for gearPoint in gearPoints
        adjacentNumbers = findAdjacentNumbers(gearPoint, input, extractedNumbers)
        if length(adjacentNumbers) == 2
            total += prod([listNumber.value for listNumber ∈ adjacentNumbers])
        end
    end
    total
end


@show answer2("input")