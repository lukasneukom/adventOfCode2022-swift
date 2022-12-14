import Cocoa

let testInput = try String(contentsOf: Bundle.main.url(forResource: "test-input", withExtension: "txt")!)
let puzzleInput = try String(contentsOf: Bundle.main.url(forResource: "puzzle-input", withExtension: "txt")!)

let expectedResultOne = "24"
let expectedResultTwo = "93"

var map = Set<String>()
var sand = Set<String>()

var mapHeight = 0
var mapWidth = 0

var restingSandGrains = 0

func buildMap(from mapInstructs: [[String.SubSequence]]) {
    mapHeight = 0
    mapWidth = 0
    map.removeAll()
    sand.removeAll()
    
    for mapInstruct in mapInstructs {
        for i in 0..<(mapInstruct.count - 1) {
            let current = mapInstruct[i].components(separatedBy: ",").map { Int($0)! }
            let next = mapInstruct[i+1].components(separatedBy: ",").map {Int($0)! }
            let minX = min(current[0],next[0])
            let maxX = max(current[0],next[0])
            let minY = min(current[1],next[1])
            let maxY = max(current[1],next[1])
            
            if maxX > mapWidth { mapWidth = maxX }
            if maxY > mapHeight { mapHeight = maxY }
            
            if minX == maxX {
                for i in minY...maxY {
                    map.insert("\(minX),\(i)")
                }
            }
            
            if minY == maxY {
                for i in minX...maxX {
                    map.insert("\(i),\(minY)")
                }
            }
        }
    }
}

func dropSand(from position: String, withFloor: Bool) -> Bool {
    let start = position.components(separatedBy: ",").map { Int($0)! }
    var (x,y) = (start[0],start[1])
//    print("dropping from \(x),\(y)")
    
    if sand.contains("\(x),\(y)") {
        print("starting position blocked by sand, everything is full")
        return false
    } // filled up
    
    while y <= (withFloor ? mapHeight+1 : mapHeight) {
        if withFloor && y == mapHeight + 1 {
            sand.insert("\(x),\(y)")
            restingSandGrains += 1
//            print("hit rock bottom, resting at \(x),\(y)\n")
            return true
        } else if !map.contains("\(x),\(y+1)") && !sand.contains("\(x),\(y+1)") {
            y = y+1
//            print("free below, falling down: \(x),\(y)")
            continue
        } else if !map.contains("\(x-1),\(y+1)") && !sand.contains("\(x-1),\(y+1)") {
            x = x-1
            y = y+1
//            print("blocked below, moving left: \(x),\(y)")
            continue
        } else if !map.contains("\(x+1),\(y+1)") && !sand.contains("\(x+1),\(y+1)") {
            x = x+1
            y = y+1
//            print("blocked below, moving right: \(x),\(y)")
            continue
        } else {
            sand.insert("\(x),\(y)")
            restingSandGrains += 1
//            print("rest at \(x),\(y)\n")
            return true
        }
    }
    print("falling through...")
    return false
}

func partOne(puzzleInput: String) -> String {
    var mapInstructs = puzzleInput.components(separatedBy: "\n").map { $0.split(separator: " -> ") }
    buildMap(from: mapInstructs)
    
    let sandHole = "500,0"

    var lastSandAtRest = true
    
    restingSandGrains = 0
    
    while lastSandAtRest {
        lastSandAtRest = dropSand(from: sandHole, withFloor: false)
//        print(restingSandGrains)
    }
    
    return "\(restingSandGrains)"
}

func partTwo(puzzleInput: String) -> String {
    var mapInstructs = puzzleInput.components(separatedBy: "\n").map { $0.split(separator: " -> ") }
    buildMap(from: mapInstructs)
    
    let sandHole = "500,0"

    var lastSandAtRest = true
    
    restingSandGrains = 0
    
    while lastSandAtRest {
        lastSandAtRest = dropSand(from: sandHole, withFloor: true)
    }
    
    return "\(restingSandGrains)"
}

let testResultOne = partOne(puzzleInput: testInput)
testResultOne == expectedResultOne ? print("Passed first test") : print("Failed first test, expected \"\(expectedResultOne)\" but got \"\(testResultOne)\"")

let resultOne = partOne(puzzleInput: puzzleInput)
print("Frist result should be: \"\(resultOne)\"")

let testResultTwo = partTwo(puzzleInput: testInput)
testResultTwo == expectedResultTwo ? print("Passed second test") : print("Failed second test, expected \"\(expectedResultTwo)\" but got \"\(testResultTwo)\"")

let resultTwo = partTwo(puzzleInput: puzzleInput)
print("Second result should be: \"\(resultTwo)\"")
