//
//  Referee.swift
//  TicTacToe
//
//  Created by Tim on 27.05.2022.
//

import Foundation

final class Referee {
    
    // MARK: - Properties
    
    public let gameboard: Gameboard
    var winningCombinations: [[GameboardPosition]] {
        var winningCombinations: [[GameboardPosition]] = []
        generateWinsByColumn(result: &winningCombinations)
        generateWinsByRow(result: &winningCombinations)
        generateWinLeftDiagonal(result: &winningCombinations)
        generateWinRightDiagonal(result: &winningCombinations)
        return winningCombinations
    }
    private var fieldSize = Game.shared.fieldSize
    
    // MARK: - Init
    
    public init(gameboard: Gameboard) {
        self.gameboard = gameboard
    }
    
    // MARK: - Public
    
    public func determineWinner() -> Player? {
        for player in Player.allCases {
            if doesPlayerHaveWinningCombination(player) { return player }
        }
        return nil
    }
    
    // MARK: - Private
    
    private func generateWinsByColumn(result: inout [[GameboardPosition]]) {
        if fieldSize == 3 {
            for column in 0 ..< fieldSize {
                var array: [GameboardPosition] = []
                for row in 0 ..< fieldSize {
                    array.append(GameboardPosition(column: column, row: row))
                }
                result.append(array)
            }
        } else if fieldSize == 7 {
            for column in 0 ..< fieldSize {
                var array: [GameboardPosition] = []
                for j in 0...3 {
                    for row in j ..< fieldSize - (3 - j) {
                        array.append(GameboardPosition(column: column, row: row))
                    }
                    result.append(array)
                    array = []
                }
            }
        }
    }
    
    private func generateWinsByRow(result: inout [[GameboardPosition]]) {
        if fieldSize == 3 {
            for row in 0 ..< fieldSize {
                var array: [GameboardPosition] = []
                for column in 0 ..< fieldSize {
                    array.append(GameboardPosition(column: column, row: row))
                }
                result.append(array)
            }
        } else if fieldSize == 7 {
            for row in 0 ..< fieldSize {
                var array: [GameboardPosition] = []
                for j in 0...3 {
                    for column in j ..< fieldSize - (3 - j) {
                        array.append(GameboardPosition(column: column, row: row))
                    }
                    result.append(array)
                    array = []
                }
            }
        }
    }

    
    private func generateWinLeftDiagonal(result: inout [[GameboardPosition]]) {
        var winsByLeftDiagonal: [[GameboardPosition]] = []
        if fieldSize == 3 {
            var array: [GameboardPosition] = []
            for i in 0 ..< fieldSize {
                array.append(GameboardPosition(column: i, row: i))
            }
            result.append(array)
        } else if fieldSize == 7 {
            var array: [[GameboardPosition]] = [[],[],[],[]]
            
            for i in 0 ..< fieldSize - 3 {
                array[0].append(GameboardPosition(column: i, row: i))
                array[1].append(GameboardPosition(column: i, row: i + 1))
                array[2].append(GameboardPosition(column: i, row: i + 2))
                array[3].append(GameboardPosition(column: i, row: i + 3))
            }
            winsByLeftDiagonal.append(contentsOf: array)
            array = [[],[],[],[]]
            
            for i in 0 ..< fieldSize - 3 {
                array[0].append(GameboardPosition(column: i + 1, row: i))
                array[1].append(GameboardPosition(column: i + 1, row: i + 1))
                array[2].append(GameboardPosition(column: i + 1, row: i + 2))
                array[3].append(GameboardPosition(column: i + 1, row: i + 3))
            }
            winsByLeftDiagonal.append(contentsOf: array)
            array = [[],[],[],[]]
            
            for i in 0 ..< fieldSize - 3 {
                array[0].append(GameboardPosition(column: i + 2, row: i))
                array[1].append(GameboardPosition(column: i + 2, row: i + 1))
                array[2].append(GameboardPosition(column: i + 2, row: i + 2))
                array[3].append(GameboardPosition(column: i + 2, row: i + 3))
            }
            winsByLeftDiagonal.append(contentsOf: array)
            array = [[],[],[],[]]
            
            for i in 0 ..< fieldSize - 3 {
                array[0].append(GameboardPosition(column: i + 3, row: i))
                array[1].append(GameboardPosition(column: i + 3, row: i + 1))
                array[2].append(GameboardPosition(column: i + 3, row: i + 2))
                array[3].append(GameboardPosition(column: i + 3, row: i + 3))
            }
            winsByLeftDiagonal.append(contentsOf: array)
        }
        result.append(contentsOf: winsByLeftDiagonal)
    }
    
    private func generateWinRightDiagonal(result: inout [[GameboardPosition]]) {
        var winsByRightDiagonal: [[GameboardPosition]] = []
        if fieldSize == 3 {
            var array: [GameboardPosition] = []
            for i in 0 ..< fieldSize {
                array.append(GameboardPosition(column: fieldSize - 1 - i, row: i))
            }
            winsByRightDiagonal.append(array)
            
        } else if fieldSize == 7 {
            
            var array: [[GameboardPosition]] = [[],[],[],[]]
            
            for i in 0 ..< fieldSize - 3 {
                array[0].append(GameboardPosition(column: GameboardSize.rows - i - 1, row: i))
                array[1].append(GameboardPosition(column: GameboardSize.rows - i - 1, row: i + 1))
                array[2].append(GameboardPosition(column: GameboardSize.rows - i - 1, row: i + 2))
                array[3].append(GameboardPosition(column: GameboardSize.rows - i - 1, row: i + 3))
            }
            winsByRightDiagonal.append(contentsOf: array)
            array = [[],[],[],[]]
            
            for i in 0 ..< fieldSize - 3 {
                array[0].append(GameboardPosition(column: GameboardSize.rows - i - 2, row: i))
                array[1].append(GameboardPosition(column: GameboardSize.rows - i - 2, row: i + 1))
                array[2].append(GameboardPosition(column: GameboardSize.rows - i - 2, row: i + 2))
                array[3].append(GameboardPosition(column: GameboardSize.rows - i - 2, row: i + 3))
            }
            winsByRightDiagonal.append(contentsOf: array)
            array = [[],[],[],[]]
            
            for i in 0 ..< fieldSize - 3 {
                array[0].append(GameboardPosition(column: GameboardSize.rows - i - 3, row: i))
                array[1].append(GameboardPosition(column: GameboardSize.rows - i - 3, row: i + 1))
                array[2].append(GameboardPosition(column: GameboardSize.rows - i - 3, row: i + 2))
                array[3].append(GameboardPosition(column: GameboardSize.rows - i - 3, row: i + 3))
            }
            winsByRightDiagonal.append(contentsOf: array)
            array = [[],[],[],[]]
            
            for i in 0 ..< fieldSize - 3 {
                array[0].append(GameboardPosition(column: GameboardSize.rows - i - 4, row: i))
                array[1].append(GameboardPosition(column: GameboardSize.rows - i - 4, row: i + 1))
                array[2].append(GameboardPosition(column: GameboardSize.rows - i - 4, row: i + 2))
                array[3].append(GameboardPosition(column: GameboardSize.rows - i - 4, row: i + 3))
            }
            winsByRightDiagonal.append(contentsOf: array)
        }
        result.append(contentsOf: winsByRightDiagonal)
    }
    
    private func doesPlayerHaveWinningCombination(_ player: Player) -> Bool {
        for winningPositions in winningCombinations {
            if gameboard.contains(player: player, at: winningPositions) { return true }
        }
        return false
    }
}

