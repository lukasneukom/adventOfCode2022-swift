import Cocoa

let puzzleInputURL = Bundle.main.url(forResource: "puzzle-input", withExtension: "txt")
let puzzleInput = try String(contentsOf: puzzleInputURL!)

var inputLeftToParse = puzzleInput.split(separator: "\n").map { $0.split(separator: " ")}

var directoryFileSizes = [String: Int]()
var currentDirectory = ""


func addUpFileSizes(inDirectory: String) -> Int {
    var sum = directoryFileSizes[inDirectory, default: 0] // set sum to current value of directory
    
    while inputLeftToParse.count > 0 {
        let cmd = inputLeftToParse.removeFirst()
        if cmd == ["$", "cd", ".."] { // leave directory and write sum
            directoryFileSizes[inDirectory] = sum
            return sum
        } else if cmd == ["$", "cd", "/"] { //
            // I don't know what to do here, or if I even have to do something
        } else if cmd[0...1] == ["$", "cd"] { // open directory and recursively add up the file sizes there
            sum += addUpFileSizes(inDirectory: inDirectory + "/" + cmd[2])
        } else if cmd[0] != "$" && cmd [0] != "dir" {
            sum += Int(cmd[0])!
        }
    }
    directoryFileSizes[inDirectory] = sum
    return sum
}

var result = addUpFileSizes(inDirectory: currentDirectory)

var totalSizeOfSmallDirectories = 0
for d in directoryFileSizes {
    if d.value < 100_000 {
        totalSizeOfSmallDirectories += d.value
    }
}
print(totalSizeOfSmallDirectories)
print()

let minNeededSpace = result - 40_000_000
print(minNeededSpace)
print()

var sufficientDirs = [Int]()
for d in directoryFileSizes {
    if d.value > minNeededSpace {
        sufficientDirs.append(d.value)
    }
}
print(sufficientDirs.min()!)


//
//
//let logLines = puzzleInput.components(separatedBy: "\n")
//var currentPath = "/"
//var allPathsAndSizes = [String: Int]()
//allPathsAndSizes[currentPath] = 0
//
//var containedDirectories = [String: [String]]()
//containedDirectories["/"] = []
//
//for logLine in logLines {
//    let parsedLog = logLine.components(separatedBy: " ")
//
//    if parsedLog[0] == "$" {
//        switch parsedLog[1] {
//        case "cd":
//            switch parsedLog[2] {
//            case "..":
//                let indexOfLastDir = currentPath.lastIndex(of: "/")
//                currentPath = String(currentPath.prefix(upTo: indexOfLastDir!))
//                if currentPath == "" {
//                    currentPath = "/"
//                }
//
//            case "/":
//                currentPath = "/"
//            default:
//                if currentPath.last == "/" {
//                    currentPath.append("\(parsedLog[2])")
//                } else {
//                    currentPath.append("/\(parsedLog[2])")
//                }
//                if allPathsAndSizes[currentPath] == nil {
//                    allPathsAndSizes[currentPath] = 0
//                }
//            }
//            print("move to directory \(currentPath)")
//        case "ls":
//            print("search contents of \(currentPath)")
//        default:
//            print("unknown command detected")
//        }
//    } else if parsedLog[0] == "dir" {
//        var newDirectory = ""
//        if currentPath.last == "/" {
//            newDirectory = currentPath + parsedLog[1]
//        } else {
//            newDirectory = currentPath + "/" + parsedLog[1]
//        }
//        if allPathsAndSizes[newDirectory] == nil {
//            allPathsAndSizes[newDirectory] = 0
//            print("found directory \(parsedLog[1]) in \(currentPath)")
//        }
//        containedDirectories[newDirectory] = []
//    } else {
//        let fileSize = Int(parsedLog[0])!
//        print(fileSize)
//            let newSize = allPathsAndSizes[currentPath]! + fileSize
//            allPathsAndSizes[currentPath] = newSize
//        print("    \(currentPath) contains \(allPathsAndSizes[currentPath]!) bytes")
//    }
//}
//
//print(containedDirectories)
//
