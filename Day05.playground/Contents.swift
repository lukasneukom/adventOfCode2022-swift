import Cocoa

// get input
let inputFileURL = Bundle.main.url(forResource: "puzzle-input", withExtension: "txt")
let puzzleInput = try String(contentsOf: inputFileURL!)

let puzzleArray = puzzleInput.components(separatedBy: "\n").split(separator: "")
let startingCondition = puzzleArray[0].reversed()
let craneInstructions = puzzleArray[1]

// initialize stacks
let numberOfStacks = startingCondition.first?.split(separator: " ", omittingEmptySubsequences: true).count
var stacks = [[String]]()
for _ in 0..<numberOfStacks! {
    stacks.append([])
}

// place starting crates
for crateLayer in startingCondition.dropFirst() {
    var remainingCrates = String(crateLayer)
    for i in 0..<numberOfStacks! {
        let crate = String(remainingCrates.dropFirst(4*i).prefix(3).trimmingCharacters(in: .whitespaces))
        if !crate.isEmpty {
            stacks[i].append(crate)
        }
    }
}

// operate crane
for instruction in craneInstructions {
    let details = instruction.components(separatedBy: " ")
    let numberOfCrates = Int(details[1])!
    let fromStack = Int(details[3])!
    let toStack = Int(details[5])!
    
    let crateLoad = stacks[fromStack - 1].suffix(numberOfCrates)
    stacks[fromStack - 1].removeLast(numberOfCrates)
    stacks[toStack - 1].append(contentsOf: crateLoad) // .reversed() for part 1 of the puzzle
}

for stack in stacks {
    print(stack.last!)
}
