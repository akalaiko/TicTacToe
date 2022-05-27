//
//  Referee.swift
//  XO-game
//
//  Created by Evgeny Kireev on 26/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

public final class Referee {
    
    // MARK: - Properties
    
    public let gameboard: Gameboard
    
    public private(set) lazy var winningCombinations: [[GameboardPosition]] = {
        var winningCombinations: [[GameboardPosition]] = []
        generateWinsByColumn(result: &winningCombinations)
        generateWinsByRow(result: &winningCombinations)
        generateWinLeftDiagonal(result: &winningCombinations)
        generateWinRightDiagonal(result: &winningCombinations)
        return winningCombinations
    }()
    
    // MARK: - Init
    
    public init(gameboard: Gameboard) {
        self.gameboard = gameboard
    }
    
    // MARK: - Public
    
    public func determineWinner() -> Player? {
        for player in Player.allCases {
            if doesPlayerHaveWinningCombination(player) {
                return player
            }
        }
        return nil
    }
    
    // MARK: - Private
    
    private func generateWinsByColumn(result: inout [[GameboardPosition]]) {
        var winsByColumns: [[GameboardPosition]] = []
        if GameboardSize.columns == 3 {
            for column in 0 ..< GameboardSize.columns {
                var array: [GameboardPosition] = []
                for row in 0 ..< GameboardSize.rows {
                    array.append(GameboardPosition(column: column, row: row))
                }
                winsByColumns.append(array)
            }
            result.append(contentsOf: winsByColumns)
        } else if GameboardSize.columns == 7 {
            for column in 0 ..< GameboardSize.columns {
                var array: [GameboardPosition] = []
                for row in 0 ..< GameboardSize.rows - 3 {
                    array.append(GameboardPosition(column: column, row: row))
                }
                winsByColumns.append(array)
                array = []
                for row in 1 ..< GameboardSize.rows - 2 {
                    array.append(GameboardPosition(column: column, row: row))
                }
                winsByColumns.append(array)
                array = []
                for row in 2 ..< GameboardSize.rows - 1 {
                    array.append(GameboardPosition(column: column, row: row))
                }
                winsByColumns.append(array)
                array = []
                for row in 3 ..< GameboardSize.rows {
                    array.append(GameboardPosition(column: column, row: row))
                }
                winsByColumns.append(array)
                array = []
            }
            result.append(contentsOf: winsByColumns)
        }
    }
    
    private func generateWinsByRow(result: inout [[GameboardPosition]]) {
        var winsByRows: [[GameboardPosition]] = []
        if GameboardSize.rows == 3 {
            for row in 0 ..< GameboardSize.rows {
                var array: [GameboardPosition] = []
                for column in 0 ..< GameboardSize.columns {
                    array.append(GameboardPosition(column: column, row: row))
                }
                winsByRows.append(array)
            }
            result.append(contentsOf: winsByRows)
        } else if GameboardSize.rows == 7 {
            for row in 0 ..< GameboardSize.rows {
                var array: [GameboardPosition] = []
                for column in 0 ..< GameboardSize.columns - 3 {
                    array.append(GameboardPosition(column: column, row: row))
                }
                winsByRows.append(array)
                array = []
                for column in 1 ..< GameboardSize.columns - 2 {
                    array.append(GameboardPosition(column: column, row: row))
                }
                winsByRows.append(array)
                array = []
                for column in 2 ..< GameboardSize.columns - 1 {
                    array.append(GameboardPosition(column: column, row: row))
                }
                winsByRows.append(array)
                array = []
                for column in 3 ..< GameboardSize.columns {
                    array.append(GameboardPosition(column: column, row: row))
                }
                winsByRows.append(array)
                array = []
            }
            result.append(contentsOf: winsByRows)
        }
    }

    
    private func generateWinLeftDiagonal(result: inout [[GameboardPosition]]) {
        guard GameboardSize.columns == GameboardSize.rows else { return }
        var winsByLeftDiagonal: [[GameboardPosition]] = []
        if GameboardSize.columns == 3 {
            var array: [GameboardPosition] = []
            for i in 0 ..< GameboardSize.columns {
                array.append(GameboardPosition(column: i, row: i))
            }
            winsByLeftDiagonal.append(array)
            
        } else if GameboardSize.rows == 7 {
            
            var array: [[GameboardPosition]] = [[],[],[],[]]
            
            for i in 0 ..< GameboardSize.rows - 3 {
                array[0].append(GameboardPosition(column: i, row: i))
                array[1].append(GameboardPosition(column: i, row: i + 1))
                array[2].append(GameboardPosition(column: i, row: i + 2))
                array[3].append(GameboardPosition(column: i, row: i + 3))
            }
            winsByLeftDiagonal.append(contentsOf: array)
            array = [[],[],[],[]]
            
            for i in 0 ..< GameboardSize.rows - 3 {
                array[0].append(GameboardPosition(column: i + 1, row: i))
                array[1].append(GameboardPosition(column: i + 1, row: i + 1))
                array[2].append(GameboardPosition(column: i + 1, row: i + 2))
                array[3].append(GameboardPosition(column: i + 1, row: i + 3))
            }
            winsByLeftDiagonal.append(contentsOf: array)
            array = [[],[],[],[]]
            
            for i in 0 ..< GameboardSize.rows - 3 {
                array[0].append(GameboardPosition(column: i + 2, row: i))
                array[1].append(GameboardPosition(column: i + 2, row: i + 1))
                array[2].append(GameboardPosition(column: i + 2, row: i + 2))
                array[3].append(GameboardPosition(column: i + 2, row: i + 3))
            }
            winsByLeftDiagonal.append(contentsOf: array)
            array = [[],[],[],[]]
            
            for i in 0 ..< GameboardSize.rows - 3 {
                array[0].append(GameboardPosition(column: i + 3, row: i))
                array[1].append(GameboardPosition(column: i + 3, row: i + 1))
                array[2].append(GameboardPosition(column: i + 3, row: i + 2))
                array[3].append(GameboardPosition(column: i + 3, row: i + 3))
            }
            winsByLeftDiagonal.append(contentsOf: array)
        }
        print(winsByLeftDiagonal)
        result.append(contentsOf: winsByLeftDiagonal)
    }
    
    private func generateWinRightDiagonal(result: inout [[GameboardPosition]]) {
        guard GameboardSize.columns == GameboardSize.rows else { return }
        var winsByRightDiagonal: [[GameboardPosition]] = []
        if GameboardSize.columns == 3 {
            var array: [GameboardPosition] = []
            for i in 0 ..< GameboardSize.rows {
                array.append(GameboardPosition(column: GameboardSize.rows - 1 - i, row: GameboardSize.rows - 1 - i))
            }
            winsByRightDiagonal.append(array)
            
        } else if GameboardSize.rows == 7 {
            
            var array: [[GameboardPosition]] = [[],[],[],[]]
            
            for i in 0 ..< GameboardSize.rows - 3 {
                array[0].append(GameboardPosition(column: GameboardSize.rows - i - 1, row: i))
                array[1].append(GameboardPosition(column: GameboardSize.rows - i - 1, row: i + 1))
                array[2].append(GameboardPosition(column: GameboardSize.rows - i - 1, row: i + 2))
                array[3].append(GameboardPosition(column: GameboardSize.rows - i - 1, row: i + 3))
            }
            winsByRightDiagonal.append(contentsOf: array)
            array = [[],[],[],[]]
            
            for i in 0 ..< GameboardSize.rows - 3 {
                array[0].append(GameboardPosition(column: GameboardSize.rows - i - 2, row: i))
                array[1].append(GameboardPosition(column: GameboardSize.rows - i - 2, row: i + 1))
                array[2].append(GameboardPosition(column: GameboardSize.rows - i - 2, row: i + 2))
                array[3].append(GameboardPosition(column: GameboardSize.rows - i - 2, row: i + 3))
            }
            winsByRightDiagonal.append(contentsOf: array)
            array = [[],[],[],[]]
            
            for i in 0 ..< GameboardSize.rows - 3 {
                array[0].append(GameboardPosition(column: GameboardSize.rows - i - 3, row: i))
                array[1].append(GameboardPosition(column: GameboardSize.rows - i - 3, row: i + 1))
                array[2].append(GameboardPosition(column: GameboardSize.rows - i - 3, row: i + 2))
                array[3].append(GameboardPosition(column: GameboardSize.rows - i - 3, row: i + 3))
            }
            winsByRightDiagonal.append(contentsOf: array)
            array = [[],[],[],[]]
            
            for i in 0 ..< GameboardSize.rows - 3 {
                array[0].append(GameboardPosition(column: GameboardSize.rows - i - 4, row: i))
                array[1].append(GameboardPosition(column: GameboardSize.rows - i - 4, row: i + 1))
                array[2].append(GameboardPosition(column: GameboardSize.rows - i - 4, row: i + 2))
                array[3].append(GameboardPosition(column: GameboardSize.rows - i - 4, row: i + 3))
            }
            winsByRightDiagonal.append(contentsOf: array)
        }
        print(winsByRightDiagonal)
        result.append(contentsOf: winsByRightDiagonal)
    }
    
    private func doesPlayerHaveWinningCombination(_ player: Player) -> Bool {
        for winningPositions in winningCombinations {
            if gameboard.contains(player: player, at: winningPositions) {
                return true
            }
        }
        return false
    }
}

