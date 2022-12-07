import Cocoa

// get input
let inputFileURL = Bundle.main.url(forResource: "puzzle-input", withExtension: "txt")
let puzzleInput = try String(contentsOf: inputFileURL!)

let elvenPairs =  puzzleInput.trimmingCharacters(in: .newlines).components(separatedBy: "\n")
var wrongAssignements = 0
var duplicateSections = 0

for pair in elvenPairs {
    let bothRanges = pair.components(separatedBy: ",")
    let firstRange = bothRanges[0].components(separatedBy: "-")
    let secondRange = bothRanges[1].components(separatedBy: "-")
    
    let startOfFirstRange = Int(firstRange[0])!
    let startOfSecondRange = Int(secondRange[0])!
    let endOfFirstRange = Int(firstRange[1])!
    let endOfSecondRange = Int(secondRange[1])!
    
    let firstSwiftRange = Int(firstRange[0])!...Int(firstRange[1])!
    let secondSwiftRange = Int(secondRange[0])!...Int(secondRange[1])!
    
    // assignements which contain each other
    if firstSwiftRange ~= secondSwiftRange.lowerBound && firstSwiftRange ~= secondSwiftRange.upperBound {
        wrongAssignements += 1
    }
    
    if secondSwiftRange ~= firstSwiftRange.lowerBound && secondSwiftRange ~= firstSwiftRange.upperBound {
        wrongAssignements += 1
    }
    
    // remove duplicates (identical first and second Range)
    if firstSwiftRange.lowerBound == secondSwiftRange.lowerBound && firstSwiftRange.upperBound == secondSwiftRange.upperBound {
        wrongAssignements -= 1
    }
    
    // assignements with duplicate sections
    if firstSwiftRange ~= secondSwiftRange.lowerBound || firstSwiftRange ~= secondSwiftRange.upperBound || secondSwiftRange ~= firstSwiftRange.lowerBound || secondSwiftRange ~= firstSwiftRange.upperBound {
        duplicateSections += 1
    }
    
//    print(firstSwiftRange)
//    print(secondSwiftRange)
//    print(duplicateSections)
}

print(wrongAssignements)
print(duplicateSections)
