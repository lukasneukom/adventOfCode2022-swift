import Cocoa

let testInput = try String(contentsOf: Bundle.main.url(forResource: "test-input", withExtension: "txt")!)
let puzzleInput = try String(contentsOf: Bundle.main.url(forResource: "puzzle-input", withExtension: "txt")!)

let expectedResultOne = "13"
let expectedResultTwo = "140"

func unpackPacket(_ packet: String) -> [Any] {
    var restOfPacket = packet
    var unpacked = [Any]()
    var currentElement = ""
    
    while !restOfPacket.isEmpty {
        let next = restOfPacket.removeFirst()
        
        switch next {
        case "[":
            let endIndex = restOfPacket.firstIndex(of: "]")!
            let distance = restOfPacket.distance(from: restOfPacket.startIndex, to: endIndex)
            var recursiveRest = String(restOfPacket.prefix(distance+1))
            restOfPacket.removeFirst(distance+1)
            unpacked.append(unpackPacket(recursiveRest))
            
        case "]":
            if !currentElement.isEmpty {
                unpacked.append(Int(currentElement)!)
                return unpacked
            }
        case ",":
            if !currentElement.isEmpty {
                unpacked.append(Int(currentElement)!)
                currentElement = ""
            }
        default:
            currentElement += String(next)
        }
    }
    
    if !currentElement.isEmpty {
        unpacked.append(Int(currentElement)!)
        currentElement = ""
}
    
    return unpacked
}

func compare(_ leftPacket: [Any], _ rightPacket: [Any]) -> Bool? {
    for i in 0..<leftPacket.count {
        if i >= rightPacket.count { return false }
        
        switch (leftPacket[i] is Int, rightPacket[i] is Int) {
        case (true, true):
            if (leftPacket[i] as! Int) > (rightPacket[i] as! Int) { return false }
            if (leftPacket[i] as! Int) < (rightPacket[i] as! Int) { return true }
            continue
        case (true, false):
            if let correctOrder = compare([leftPacket[i]], rightPacket[i] as! [Any]) { return correctOrder }
            continue
        case (false, true):
            if let correctOrder = compare(leftPacket[i] as! [Any], [rightPacket[i]]) { return correctOrder }
            continue
        case (false, false):
            if let correctOrder = compare(leftPacket[i] as! [Any], rightPacket[i] as! [Any]) { return correctOrder }
            continue
        }
    }
    if leftPacket.count < rightPacket.count { return true }
    return nil
}

func partOne(puzzleInput: String) -> String {
    var leftToParse = puzzleInput.components(separatedBy: "\n\n").map { $0.split(separator: "\n") }
    var sumOfIndices = 0
    
    for i in 1...leftToParse.count {
        let leftPacket = String(leftToParse[i-1][0].dropFirst().dropLast())
        let rightPacket = String(leftToParse[i-1][1].dropFirst().dropLast())
        let l = unpackPacket(leftPacket)
        let r = unpackPacket(rightPacket)
        let inRightOrder = compare(l,r)
        print("comparing:\n\(l)\n\(r)\norder is \(inRightOrder)\n")
        if inRightOrder ?? false { sumOfIndices += i }
    }
    
    return "\(sumOfIndices)"
}

func partTwo(puzzleInput: String) -> String {
    var leftToParse = puzzleInput.components(separatedBy: "\n\n").map { $0.split(separator: "\n") }
    let two: [Any] = [[2]]
    let six: [Any] = [[6]]
    
    var indexOfTwo = 1
    var indexOfSix = 2
    
    for i in 1...leftToParse.count {
        let firstPacket = String(leftToParse[i-1][0].dropFirst().dropLast())
        let secondPacket = String(leftToParse[i-1][1].dropFirst().dropLast())
        let first = unpackPacket(firstPacket)
        let second = unpackPacket(secondPacket)
        
        let twoBeforeFirst = compare(two, first)!
        let twoBeforeSecond = compare(two, second)!
        let sixBeforeFirst = compare(six, first)!
        let sixBeforeSecond = compare(six, second)!
        
        print(first)
        print("[[2]] in front? \(twoBeforeFirst), [[6]] in front? \(sixBeforeFirst)\n")
        
        print(second)
        print("[[2]] in front? \(twoBeforeSecond), [[6]] in front? \(sixBeforeSecond)\n")
        
        
        if !twoBeforeFirst { indexOfTwo += 1 }
        if !twoBeforeSecond { indexOfTwo += 1 }
        if !sixBeforeFirst { indexOfSix += 1 }
        if !sixBeforeSecond { indexOfSix += 1 }
    }
    
    return "\(indexOfSix * indexOfTwo)"
}

let testResultOne = partOne(puzzleInput: testInput)
testResultOne == expectedResultOne ? print("Passed first test") : print("Failed first test, expected \"\(expectedResultOne)\" but got \"\(testResultOne)\"")

let resultOne = partOne(puzzleInput: puzzleInput)
print("Frist result should be: \"\(resultOne)\"")

let testResultTwo = partTwo(puzzleInput: testInput)
testResultTwo == expectedResultTwo ? print("Passed second test") : print("Failed second test, expected \"\(expectedResultTwo)\" but got \"\(testResultTwo)\"")

let resultTwo = partTwo(puzzleInput: puzzleInput)
print("Second result should be: \"\(resultTwo)\"")
    