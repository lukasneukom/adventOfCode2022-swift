import Cocoa

let testInput = try String(contentsOf: Bundle.main.url(forResource: "test-input", withExtension: "txt")!)
let puzzleInput = try String(contentsOf: Bundle.main.url(forResource: "puzzle-input", withExtension: "txt")!)

let expectedResultOne = "31"
let expectedResultTwo = "29"

func partOne(puzzleInput: String) -> String {
    var start = [0,0]
    var end = [0,0]
    
    var frontier = [[Int]]()
    var visited = Set<[Int]>()
    var heights = [[Int]: Int]()
    var cameFrom = [[Int]: [Int]]()
    
    var grid = puzzleInput.components(separatedBy: "\n").map { Array($0) }
    for i in 0..<grid.count {
        for j in 0..<grid[0].count {
            if grid[i][j] == "S" {
                start = [i, j]
                grid[i][j] = Array("a").first!
            } else if grid[i][j] == "E" {
                end = [i, j]
                grid[i][j] = Array("z").first!
            }
            heights[[i, j]] = Int(grid[i][j].asciiValue!)
        }
    }
    
    frontier.append(start)
    visited.insert(start)
    cameFrom[start] = [-100, -100]
    
    func checkAdjacent(of: [Int]) -> [[Int]] {
        var possiblePaths = [[Int]]()
        let x = of[0]
        let y = of[1]
        let z = heights[of]!
        let xPlus = heights[[x+1,y]] ?? 1000
        let xMinus = heights[[x-1,y]] ?? 1000
        let yPlus = heights[[x,y+1]] ?? 1000
        let yMinus = heights[[x,y-1]] ?? 1000

        if z >= xPlus - 1 {
            possiblePaths.append([x+1,y])
        }
        if z >= xMinus - 1 {
            possiblePaths.append([x-1,y])
        }
        if z >= yPlus - 1 {
            possiblePaths.append([x,y+1])
        }
        if z >= yMinus - 1 {
            possiblePaths.append([x,y-1])
        }
        return possiblePaths
    }

    
    while frontier.count > 0 {
        let current = frontier.removeFirst()
        
        if current == end {
            break
        }
        
        let next = checkAdjacent(of: current)
        for adjacent in next {
            if cameFrom[adjacent] == nil {
                frontier.append(adjacent)
                cameFrom[adjacent] = current
            }
        }
    }
    
    var current = end
    var path = [[Int]]()
    
    while current != start {
        path.append(current)
        current = cameFrom[current]!
    }
    return "\(path.count)"
}

func partTwo(puzzleInput: String) -> String {
    var start = [0,0]
    var end = [0,0]

    var heights = [[Int]: Int]()
    
    var grid = puzzleInput.components(separatedBy: "\n").map { Array($0) }
    for i in 0..<grid.count {
        for j in 0..<grid[0].count {
            if grid[i][j] == "S" {
                grid[i][j] = Array("a").first!
            } else if grid[i][j] == "E" {
                start = [i, j]
                grid[i][j] = Array("z").first!
            }
            heights[[i, j]] = Int(grid[i][j].asciiValue!)
        }
    }
    
    var frontier = [[Int]]()
    var cameFrom = [[Int]: [Int]]()
        
    frontier.append(start)
    cameFrom[start] = [-100, -100]
        
    func checkAdjacent(of: [Int]) -> [[Int]] {
        var possiblePaths = [[Int]]()
        let x = of[0]
        let y = of[1]
        let z = heights[of]!
        let xPlus = heights[[x+1,y]] ?? 0
        let xMinus = heights[[x-1,y]] ?? 0
        let yPlus = heights[[x,y+1]] ?? 0
        let yMinus = heights[[x,y-1]] ?? 0

            if z <= xPlus + 1 {
                possiblePaths.append([x+1,y])
            }
            if z <= xMinus + 1 {
                possiblePaths.append([x-1,y])
            }
            if z <= yPlus + 1 {
                possiblePaths.append([x,y+1])
            }
            if z <= yMinus + 1 {
                possiblePaths.append([x,y-1])
            }
            return possiblePaths
        }

        
    while frontier.count > 0 {
        let current = frontier.removeFirst()
        
        if heights[current] == 97 {
            end = current
            break
        }
        
        let next = checkAdjacent(of: current)
        for adjacent in next {
            if cameFrom[adjacent] == nil {
                frontier.append(adjacent)
                cameFrom[adjacent] = current
            }
        }
    }
        
    var current = end
    var path = [[Int]]()
    
    while current != start {
        path.append(current)
        current = cameFrom[current]!
    }
    return "\(path.count)"
}

//let testResultOne = partOne(puzzleInput: testInput)
//testResultOne == expectedResultOne ? print("Passed first test") : print("Failed first test, expected \"\(expectedResultOne)\" but got \"\(testResultOne)\"")
//
//let resultOne = partOne(puzzleInput: puzzleInput)
//print("Frist result should be: \"\(resultOne)\"")

let testResultTwo = partTwo(puzzleInput: testInput)
testResultTwo == expectedResultTwo ? print("Passed second test") : print("Failed second test, expected \"\(expectedResultTwo)\" but got \"\(testResultTwo)\"")

let resultTwo = partTwo(puzzleInput: puzzleInput)
print("Second result should be: \"\(resultTwo)\"")

