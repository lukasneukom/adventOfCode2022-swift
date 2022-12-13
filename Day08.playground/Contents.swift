import Cocoa

let puzzleInputURL = Bundle.main.url(forResource: "puzzle-input", withExtension: "txt")
let puzzleInput = try String(contentsOf: puzzleInputURL!)

let treeHeightStrings = puzzleInput.components(separatedBy: "\n").compactMap { $0.split(separator: "") }

var treeHeights = [[Int]]()
for treeHeightString in treeHeightStrings {
    treeHeights.append(treeHeightString.map { Int($0)! })
}

let mapHeight = treeHeights.count
let mapWidth = treeHeights.first?.count ?? 0

var treeIsVisible = [[Bool]](repeating: [Bool](repeating: false, count: mapWidth), count: mapHeight)

var visibleTrees = 0

for i in 0..<mapHeight {
    for j in 0..<mapWidth {
        if i == 0 || j == 0 || i == mapHeight - 1 || j == mapWidth - 1 {
            // print("\(treeHeights[i][j]) is visible (on border)")
            visibleTrees += 1
            continue
        }
        
        let height = treeHeights[i][j]
        
        if height > treeHeights[0..<i].map({ $0[j] }).max() ?? -1 {
            // print("\(height) is visible from north")
            visibleTrees += 1
        } else if height > treeHeights[i+1..<mapWidth].map({ $0[j] }).max() ?? -1 {
            // print("\(height) is visible from south")
            visibleTrees += 1
        } else if height > treeHeights[i][0..<j].max() ?? -1 {
            // print("\(height) is visible from west")
            visibleTrees += 1
        } else if height > treeHeights[i][j+1..<mapHeight].max() ?? -1 {
            // print("\(height) is visible from east")
            visibleTrees += 1
        } else {
            // print("\(height) ist not visible")
        }
    }
}

print("\(visibleTrees) trees are visible")

func viewDistanceNorth(y: Int, x: Int) -> Int {
    if y == 0 { return 0 }
    
    let height = treeHeights[y][x]
    var viewDistance = 0
    
    for i in 0..<y {
        viewDistance += 1
        if treeHeights[y-1-i][x] >= height { break }
    }
    return viewDistance
}

func viewDistanceSouth(y: Int, x: Int) -> Int {
    if y == mapHeight-1 { return 0 }
    
    let height = treeHeights[y][x]
    var viewDistance = 0
    
    for i in y+1..<mapHeight {
        viewDistance += 1
        if treeHeights[i][x] >= height { break }
    }
    return viewDistance
}

func viewDistanceEast(y: Int, x: Int) -> Int {
    if x == 0 { return 0 }
    
    let height = treeHeights[y][x]
    var viewDistance = 0
    
    for i in 0..<x {
        viewDistance += 1
        if treeHeights[y][x-1-i] >= height { break }
    }
    return viewDistance
}

func viewDistanceWest(y: Int, x: Int) -> Int {
    if x == mapWidth-1 { return 0 }
    
    let height = treeHeights[y][x]
    var viewDistance = 0
    
    for i in x+1..<mapWidth {
        viewDistance += 1
        if treeHeights[y][i] >= height { break }
    }
    return viewDistance
}

func scenicView(y: Int, x: Int) -> Int {
    return viewDistanceNorth(y: y, x: x) * viewDistanceSouth(y: y, x: x) * viewDistanceWest(y: y, x: x) * viewDistanceEast(y: y, x: x)
}

var maxScenicView = 0

for i in 0..<mapHeight {
    for j in 0..<mapWidth {
        let s = scenicView(y: i, x: j)
        if s > maxScenicView {
            maxScenicView = s
        }
    }
}

print("best scenic view has a score of \(maxScenicView)")
