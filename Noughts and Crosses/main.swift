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

func playerWin() -> Bool {
    if playerState {
        print("\(player1Name) has won!")
    } else {
        print("\(player2Name) has won!")
    }
    return true
}

func enterMove() {
    var row = 0
    var column = 0
    print("Enter the row number to place your mark")
    while let rowInput = readLine() {
        guard let rowInt = Int(rowInput), rowInt <= board.count else {
            print("Please enter a valid number")
            continue
        }
        row = rowInt - 1
        break
    }
    print("Enter the column number to place your mark")
    while let columnInput = readLine() {
        guard let columnInt = Int(columnInput), columnInt <= board.count else {
            print("Please enter a valid number")
            continue
        }
        column = columnInt - 1
        break
    }
    if board[row][column] != nil {
        print("That spot is already taken, please choose another.")
        return
    }
    if playerState {
        board[row][column] = true
    } else {
        board[row][column] = false
    }
    playerState.toggle()
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
        let allTrueRow = row.allSatisfy({ $0 == true })
        let allFalseRow = row.allSatisfy({ $0 == false })
        if !row.contains(nil) && (allTrueRow || allFalseRow) {
            return playerWin()
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
        let allTrueСolumnElements = columnElements.allSatisfy({ $0 == true })
        let allFalseСolumnElements = columnElements.allSatisfy({ $0 == false })
        if (allTrueСolumnElements || allFalseСolumnElements) && columnElements.count == board.count {
            return playerWin()
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
    let allTrueCrossMain = crossMain.allSatisfy({ $0 == true })
    let allFalseCrossMain = crossMain.allSatisfy({ $0 == false })
    let allTrueCrossAux = crossAux.allSatisfy({ $0 == true })
    let allFalseCrossAux = crossAux.allSatisfy({ $0 == false })
    if ((allTrueCrossMain || allFalseCrossMain) && crossMain.count == board.count) || ((allTrueCrossAux || allFalseCrossAux) && crossAux.count == board.count) {
        return playerWin()
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
    while let boardSizeString = readLine() {
        guard let boardSizeInt = Int(boardSizeString) else {
            print("Invalid input. Please enter correct size of the board")
            continue
        }
        boardSize = boardSizeInt
        break
    }
    board = Array(repeating: Array(repeating: nil, count: boardSize), count: boardSize)
    while true {
        printField()
        switch playerState {
        case true:
            print("\(player1Name)'s turn")
        case false:
            print("\(player2Name)'s turn")
        }
        enterMove()
        if checkWinRow() || checkWinColumn() || checkWinCross() {
            printField()
            break
        }
    }
}
