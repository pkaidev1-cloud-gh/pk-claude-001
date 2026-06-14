import SwiftUI

struct ContentView: View {
    @State private var board: [String?] = Array(repeating: nil, count: 9)
    @State private var currentPlayer = "X"
    @State private var gameOver = false
    @State private var winningLine: [Int]? = nil

    static let winLines: [[Int]] = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8],
        [0, 3, 6], [1, 4, 7], [2, 5, 8],
        [0, 4, 8], [2, 4, 6]
    ]

    var statusText: String {
        if let line = winningLine, let winner = board[line[0]] {
            return "Player \(winner) wins!"
        } else if gameOver {
            return "It's a draw!"
        } else {
            return "Player \(currentPlayer)'s turn"
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.12, green: 0.11, blue: 0.17), Color(red: 0.57, green: 0.55, blue: 0.67)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("TIC TAC TOE")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .tracking(2)

                Text(statusText)
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(minHeight: 28)

                boardView
                    .frame(maxWidth: 480, maxHeight: 480)
                    .aspectRatio(1, contentMode: .fit)

                Button(action: resetGame) {
                    Text("Restart")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(red: 0.12, green: 0.11, blue: 0.17))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(Color(red: 0.30, green: 0.83, blue: 1.0))
                        .cornerRadius(10)
                }
                .buttonStyle(.plain)
            }
            .padding(24)
            .frame(maxWidth: 520)
        }
    }

    private var boardView: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let gap: CGFloat = 8
            let cellSize = (size - gap * 2) / 3

            VStack(spacing: gap) {
                ForEach(0..<3) { row in
                    HStack(spacing: gap) {
                        ForEach(0..<3) { col in
                            cellView(index: row * 3 + col, size: cellSize)
                        }
                    }
                }
            }
            .frame(width: size, height: size)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }

    @ViewBuilder
    private func cellView(index: Int, size: CGFloat) -> some View {
        let value = board[index]
        let isWinningCell = winningLine?.contains(index) ?? false

        Text(value ?? "")
            .font(.system(size: size * 0.45, weight: .bold))
            .foregroundColor(value == "X" ? Color(red: 1.0, green: 0.42, blue: 0.42) : Color(red: 0.30, green: 0.83, blue: 1.0))
            .frame(width: size, height: size)
            .background(isWinningCell ? Color.yellow.opacity(0.35) : Color.white.opacity(0.1))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isWinningCell ? Color.yellow : Color.white.opacity(0.3), lineWidth: 2)
            )
            .cornerRadius(12)
            .contentShape(Rectangle())
            .onTapGesture {
                handleMove(index)
            }
    }

    private func handleMove(_ index: Int) {
        guard !gameOver, board[index] == nil else { return }

        board[index] = currentPlayer

        if let line = checkWinner() {
            winningLine = line
            gameOver = true
            return
        }

        if board.allSatisfy({ $0 != nil }) {
            gameOver = true
            return
        }

        currentPlayer = currentPlayer == "X" ? "O" : "X"
    }

    private func checkWinner() -> [Int]? {
        Self.winLines.first { line in
            line.allSatisfy { board[$0] == currentPlayer }
        }
    }

    private func resetGame() {
        board = Array(repeating: nil, count: 9)
        currentPlayer = "X"
        gameOver = false
        winningLine = nil
    }
}
