import Cocoa

let puzzleInputURL = Bundle.main.url(forResource: "puzzle-input", withExtension: "txt")
let puzzleInput = try String(contentsOf: puzzleInputURL!)

var instructionsLeftToParse = puzzleInput.components(separatedBy: "\n").map { $0.split(separator: " ") }

var X = 1 // sprite position from x-1 to x+1
var cycle = 1
var sumOfSignalStrength = 0
var currentCRTLine = ""
var CRT = [String]()

func runCycle() {
    // print pixel
    let position = (cycle - 1)%40
    abs(position - X) < 2 ? currentCRTLine.append("#") : currentCRTLine.append(".")
    print("Sprite position is \(X)")
    print("Drawing pixel \(position)")
    print(currentCRTLine)
    print()
    
    if cycle%40 == 0 {
        // print("during cycle \(cycle), signal strength is \(cycle) * \(X)")
        // sumOfSignalStrength += cycle * X
        CRT.append(currentCRTLine)
        currentCRTLine = ""
    }
    cycle += 1
}

while instructionsLeftToParse.count > 0 {
    let cmd = instructionsLeftToParse.removeFirst()
    switch cmd[0] {
    case "noop":
        runCycle()
    case "addx":
        runCycle()
        runCycle()
        X += Int(cmd[1])!
    default:
        print("there was something wrong in the instructions")
    }
}

// print("\nsum of all signal strengths is \(sumOfSignalStrength)")

CRT.map { print($0) }
