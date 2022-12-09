import Cocoa

let puzzleInputURL = Bundle.main.url(forResource: "puzzle-input", withExtension: "txt")
let puzzleInput = try String(contentsOf: puzzleInputURL!).components(separatedBy: "\n").map { $0.split(separator: " ")}

var visitedPositions = Set<String>()
var inputLeftToParse = puzzleInput

var headX = 0
var headY = 0
var tailX = 0
var tailY = 0
visitedPositions.insert("0, 0")


func moveUp() {
    headY += 1
    if headY - tailY > 1 {
        if headX == tailX {
            tailY += 1
        } else {
            tailX = headX
            tailY += 1
        }
        visitedPositions.insert("\(tailX), \(tailY)")
    }
}

func moveDown() {
    headY -= 1
    if headY - tailY < -1 {
        if headX == tailX {
            tailY -= 1
        } else {
            tailX = headX
            tailY -= 1
        }
        visitedPositions.insert("\(tailX), \(tailY)")
    }
}

func moveLeft() {
    headX -= 1
    if headX - tailX < -1 {
        if headY == tailY {
            tailX -= 1
        } else {
            tailY = headY
            tailX -= 1
        }
        visitedPositions.insert("\(tailX), \(tailY)")
    }
}

func moveRight() {
    headX += 1
    if headX - tailX > 1 {
        if headY == tailY {
            tailX += 1
        } else {
            tailY = headY
            tailX += 1
        }
        visitedPositions.insert("\(tailX), \(tailY)")
    }
}

func printPositions() {
    print("head is at \(headX), \(headY)")
    print("tail is at \(tailX), \(tailY)")
    print()
}

while inputLeftToParse.count > 0 {
    let cmd = inputLeftToParse.removeFirst()
    switch cmd[0] {
    case "U":
        for _ in 1...Int(cmd[1])! { moveUp() }
    case "D":
        for _ in 1...Int(cmd[1])! { moveDown() }
    case "L":
        for _ in 1...Int(cmd[1])! { moveLeft() }
    case "R":
        for _ in 1...Int(cmd[1])! { moveRight() }
    default:
        print("unknown command")
        break
    }
}

print("tail visited \(visitedPositions.count) positions in part 1")

// part 2
// initialize rope
var rope = [[Int]]()
for _ in 0...9 {rope.append([0,0])}

var visitedPositionsTail = Set<String>()
visitedPositionsTail.insert("0, 0")

var ropeMovesLeft = puzzleInput
// var ropeMovesLeft = [["R", "5"], ["U", "8"], ["L", "8"]]

func moveHeadUp(startingAtX x: Int, andAtY y: Int) -> (endsOnX: Int, endsOnY: Int) { (x,y+1) }
func moveHeadDown(startingAtX x: Int, andAtY y: Int) -> (endsOnX: Int, endsOnY: Int) { (x,y-1) }
func moveHeadLeft(startingAtX x: Int, andAtY y: Int) -> (endsOnX: Int, endsOnY: Int) { (x-1,y) }
func moveHeadRight(startingAtX x: Int, andAtY y: Int) -> (endsOnX: Int, endsOnY: Int) { (x+1,y) }

func moveKnot(startingAtX x: Int, andAtY y: Int, behind knot: [Int]) -> (Int, Int) {
    let headX = knot[0]
    let headY = knot[1]
    var newX = x
    var newY = y
    
    // diagonals
    if abs(headX-x) > 1 && abs(headY-y) > 1 {
        newX += x < headX ? 1 : -1
        newY += y < headY ? 1 : -1
    } else if abs(headX-x) > 1 {
        // move left or right
        newX += x < headX ? 1 : -1
        newY = y == headY ? y : headY
    } else if abs(headY-y) > 1 {
        // up or down
        newX = x == headX ? x : headX
        newY += y < headY ? 1 : -1
    }
    
    return(newX, newY)
}

while ropeMovesLeft.count > 0 {
    let cmd = ropeMovesLeft.removeFirst()
    switch cmd[0] {
    case "U":
        for _ in 1...Int(cmd[1])! {
            let (x,y) = moveHeadUp(startingAtX: rope[0][0], andAtY: rope[0][1])
            rope[0] = [x,y]
            for i in 1..<rope.count {
                let (x,y) = moveKnot(startingAtX: rope[i][0], andAtY: rope[i][1], behind: rope[i-1])
                rope[i] = [x,y]
            }
            visitedPositionsTail.insert("\(rope[9][0]), \(rope[9][1])")
            // print(rope)
        }
    case "D":
        for _ in 1...Int(cmd[1])! {
            let (x,y) = moveHeadDown(startingAtX: rope[0][0], andAtY: rope[0][1])
            rope[0] = [x,y]
            for i in 1..<rope.count {
                let (x,y) = moveKnot(startingAtX: rope[i][0], andAtY: rope[i][1], behind: rope[i-1])
                rope[i] = [x,y]
            }
            visitedPositionsTail.insert("\(rope[9][0]), \(rope[9][1])")
            // print(rope)
        }
    case "L":
        for _ in 1...Int(cmd[1])! {
            let (x,y) = moveHeadLeft(startingAtX: rope[0][0], andAtY: rope[0][1])
            rope[0] = [x,y]
            for i in 1..<rope.count {
                let (x,y) = moveKnot(startingAtX: rope[i][0], andAtY: rope[i][1], behind: rope[i-1])
                rope[i] = [x,y]
            }
            visitedPositionsTail.insert("\(rope[9][0]), \(rope[9][1])")
            // print(rope)
        }
    case "R":
        for _ in 1...Int(cmd[1])! {
            let (x,y) = moveHeadRight(startingAtX: rope[0][0], andAtY: rope[0][1])
            rope[0] = [x,y]
            for i in 1..<rope.count {
                let (x,y) = moveKnot(startingAtX: rope[i][0], andAtY: rope[i][1], behind: rope[i-1])
                rope[i] = [x,y]
            }
            visitedPositionsTail.insert("\(rope[9][0]), \(rope[9][1])")
            // print(rope)
        }
    default:
        print("unknown command")
        break
    }
}

print("tail visited \(visitedPositionsTail.count) positions in part 2")
