import Cocoa

// get input
let inputFileURL = Bundle.main.url(forResource: "puzzle-input", withExtension: "txt")
let puzzleInput = try String(contentsOf: inputFileURL!)

// define a collection of priorities
let allItemTypes = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
var priority = [Character: Int]()
var i = 1

for item in allItemTypes {
    priority[item] = i
    i += 1
}

// find misplaced items
let rucksacks =  puzzleInput.components(separatedBy: "\n")
var misplacedItems = Array<Character>()

for rucksack in rucksacks {
    let numberOfItems = rucksack.count
    let firstCompartment = rucksack.prefix(numberOfItems / 2)
    let secondCompartment = rucksack.suffix(numberOfItems / 2)
    
    for item in firstCompartment {
        if secondCompartment.contains(item) {
            misplacedItems.append(item)
            break
        }
    }
}

// add priorites
var totalPriority = 0

for item in misplacedItems {
    totalPriority += priority[item, default: 0]
}
print(totalPriority)


// find common item in elven groups
var commonItems = Array<Character>()

for i in 1 ... rucksacks.count / 3 {
    for item in rucksacks[3 * i - 3] { // of first elf in group (3*i - 3)
        if rucksacks[3 * i - 2].contains(item) { // second elf in group (3*i - 2)
            if rucksacks[3 * i - 1].contains(item) { // third elf in group (3*i - 1)
                commonItems.append(item)
                break
            }
        }
    }
}

var totalBadgePriority = 0

for item in commonItems {
    totalBadgePriority += priority[item, default: 0]
}
print(totalBadgePriority)
