import Cocoa

let puzzleInputURL = Bundle.main.url(forResource: "puzzle-input", withExtension: "txt")
let testInputURL = Bundle.main.url(forResource: "test-input", withExtension: "txt")

let puzzleInput = try String(contentsOf: puzzleInputURL!)
let testInput = try String(contentsOf: testInputURL!)

struct Monkey {
    var items: [Int]
    let operation: (Int) -> Int
    let testDivisibleBy: Int
    let ifTrueTestThrowTo: Int
    let ifFalseTestThrowTo: Int
    var inspectedItems = 0
    
    mutating func inspectAllItems() {
        items = items.map { operation($0) % 9699690 }
        inspectedItems += items.count
    }
    
    mutating func throwOneItem() -> (item: Int, reciever: Int) {
        if items.first! % testDivisibleBy == 0 {
            return (items.removeFirst(), ifTrueTestThrowTo)
        } else {
            return (items.removeFirst(), ifFalseTestThrowTo)
        }
    }
}

var testMonkeyNotes = testInput.components(separatedBy: "\n\n").map { $0.split(separator: "\n") }
var monkeyNotes = puzzleInput.components(separatedBy: "\n\n").map { $0.split(separator: "\n")}

var monkeys: [Monkey] = []

while monkeyNotes.count > 0 {
    let monkey = monkeyNotes.removeFirst()
    var items = monkey[1].dropFirst(18).components(separatedBy: ", ").map { Int($0)! }
    var opString = monkey[2].dropFirst(19).components(separatedBy: " ")
    var operation = { (old: Int) in
        var op1 = opString[0] == "old" ? old : Int(opString[0])!
        var op2 = opString[2] == "old" ? old : Int(opString[2])!
        switch opString[1] {
        case "+":
            return op1 + op2
        case "-":
            return op1 - op2
        case "*":
            return op1 * op2
        case "/":
            return op1 / op2
        default:
            return 0
        }
    }
    var divisor = Int(monkey[3].dropFirst(21))!
    var trueMonkey = Int(monkey[4].dropFirst(29))!
    var falseMonkey = Int(monkey[5].dropFirst(30))!
    
    monkeys.append(Monkey(items: items, operation: operation, testDivisibleBy: divisor, ifTrueTestThrowTo: trueMonkey, ifFalseTestThrowTo: falseMonkey))
}


// run rounds
for _ in 0...9999 {
    for i in 0..<monkeys.count {
        if monkeys[i].items.count > 0 {
            monkeys[i].inspectAllItems()

        }
        while monkeys[i].items.count > 0 {
            let (item, to) = monkeys[i].throwOneItem()
            monkeys[to].items.append(item)
        }
    }
}

let mostActiveMonkeys = monkeys.sorted(by: { $0.inspectedItems > $1.inspectedItems } )
print(mostActiveMonkeys[0].inspectedItems * mostActiveMonkeys[1].inspectedItems)
