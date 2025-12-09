import Darwin

let symbols = (
    nothing: " ",
    player1: "X",
    player2: "O"
)

var player1Name: String = ""
var player2Name: String = ""

var boardSize = 0

var board: [[Bool?]] = []

var playerState = true

func currentPlayerText(_ playerText: String) -> String {
    if playerState {
        return "\(player1Name + playerText)"
    } else {
        return "\(player2Name + playerText)"
    }
}

func allSame(_ elements: [Bool?]) -> Bool {
    if playerState {
        return elements.allSatisfy({ $0 == true })
    } else {
        return elements.allSatisfy({ $0 == false })
    }
}

func enterValue(targetVar: inout Int, limit: Int) {
    while let input = readLine() {
        guard let inputInt = Int(input), inputInt >= limit else {
            print("Please enter a valid value")
            continue
        }
        targetVar = inputInt
        break
    }
}

func enterMove() -> Bool {
    var row = 0
    var column = 0
    print("Enter the row number to place your mark")
    enterValue(targetVar: &row, limit: 1)
    print("Enter the column number to place your mark")
    enterValue(targetVar: &column, limit: 1)
    if row > boardSize || column > boardSize {
        print("That spot is not on the board, please choose another.")
        return false
    }
    let rowIndex = row - 1
    let columnIndex = column - 1
    if board[rowIndex][columnIndex] != nil {
        print("That spot is already taken, please choose another.")
        return false
    }
    if playerState {
        board[rowIndex][columnIndex] = true
    } else {
        board[rowIndex][columnIndex] = false
    }
    return true
}

func printField() {
    var fieldFormattedString: String = "\n"
    for row in board {
        fieldFormattedString += "|"
        for cell in row {
            switch cell {
            case true: fieldFormattedString += symbols.player1
            case false: fieldFormattedString += symbols.player2
            case nil: fieldFormattedString += symbols.nothing
            }
            fieldFormattedString += "|"
        }
        fieldFormattedString += "\n"
    }
    print(fieldFormattedString)
}

func checkWinRow() -> Bool {
    for row in board {
        if !row.contains(nil) && allSame(row) {
            return true
        }
    }
    return false
}

func checkWinColumn() -> Bool {
    for rowCount in 0..<board.count {
        var columnElements: [Bool?] = []
        for row in board {
            columnElements.append(row[rowCount])
        }
        if allSame(columnElements) && columnElements.count == board.count {
            return true
        }
    }
    return false
}
    
func checkWinCross() -> Bool {
    var crossMain: [Bool?] = []
    var crossAux: [Bool?] = []
    var crossCount = 0
    for row in board {
        crossMain.append(row[crossCount])
        crossAux.append(row[board.count - 1 - crossCount])
        crossCount += 1
    }
    if (allSame(crossMain) && crossMain.count == board.count)
        || (allSame(crossAux) && crossAux.count == board.count) {
        return true
    }
    return false
}

print("Welcome to Noughts and Crosses!")
while true {
    print("For a new game, enter 'b'. To exit, enter 'q'.")
    let startGame = readLine() ?? "q"
    switch startGame {
    case "b":
        break
    case "q":
        exit(0)
    default:
        print("Invalid input. Please enter 'b' or 'q'")
        continue
    }
    print("Please enter the player 1 name:")
    let enterPlayer1Name = readLine() ?? "Player 1"
    print("Please enter the player 2 name:")
    let enterPlayer2Name = readLine() ?? "Player 2"
    player1Name = enterPlayer1Name
    player2Name = enterPlayer2Name
    print("Please enter the size of the board:")
    enterValue(targetVar: &boardSize, limit: 3)
    board = Array(repeating: Array(repeating: nil, count: boardSize), count: boardSize)
    while true {
        printField()
        print(currentPlayerText("'s turn"))
        if enterMove() {
            if checkWinRow() || checkWinColumn() || checkWinCross() {
                print(currentPlayerText(" has won!"))
                break
            }
            playerState.toggle()
        }
    }
}
