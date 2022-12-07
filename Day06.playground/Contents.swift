import Cocoa

let puzzleInputURL = Bundle.main.url(forResource: "puzzle-input", withExtension: "txt")
var puzzleInput = try String(contentsOf: puzzleInputURL!)

let markerLength = 14
for i in 0..<(puzzleInput.count - markerLength) {
    let uniqueCharsInSequence = Set(puzzleInput.prefix(markerLength)).count
    if uniqueCharsInSequence == markerLength {
        print(i+markerLength)
        break
    }
    puzzleInput.removeFirst()
}
