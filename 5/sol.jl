using DelimitedFiles
using Markdown


md"# First part"

##
1
ranges = [1:3, 10:20, 30:50]
[1:3...,50:300...]
[number for range in ranges for number in range]

# cd("5/")
filename = "example1"
input = readlines(filename)

input
line = input[3]
':' ∈ line
split(line,' ')[1]
maps = []

mutable struct ExtractedMap
    name::String
    lines
end

##

lines = []
extractedMaps = ExtractedMap[]
let mapName
    for line in input[3:end]
        if ':' ∈ line
            if length(lines) > 0
                push!(extractedMaps,ExtractedMap(mapName,lines))
                global lines = []
            end
            mapName = split(line,' ')[1]
        elseif "" != line
            push!(lines,line)
            # @show split(line,' ')[1]
        end
    end
end
lines
extractedMaps
##
extractedMap = extractedMaps[1].lines[1]
lineVector = parse.(Int,split(extractedMap))

[x:lineVector for x in lineVector]


