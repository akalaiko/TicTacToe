//
//  Gameboard.swift
//  TicTacToe
//
//  Created by Tim on 25.05.2022.
//

import Foundation

public final class Gameboard {
    
    // MARK: - Properties
    
    lazy var positions: [[Player?]] = initialPositions()
    
    // MARK: - public
    
    func setPlayer(_ player: Player, at position: GameboardPosition) {
        positions[position.column][position.row] = player
    }
    
    public func clear() {
        self.positions = initialPositions()
    }
    
    public func contains(player: Player, at positions: [GameboardPosition]) -> Bool {
        var number = 0
        for position in positions {
            guard containsAtExactPosition(player: player, at: position) else { return false }
            number += 1
        }
        if GameboardSize.rows == 3 {
            return number == 3
        } else {
            return number > 3
        }
    }
    
    public func containsAnything(at position: GameboardPosition) -> Bool {
        let (column, row) = (position.column, position.row)
        return positions[column][row] != nil
    }
    
    public func howManyTimesContains(player: Player, at positions: [GameboardPosition]) -> Int {
        var number = 0
        for position in positions {
            if containsAtExactPosition(player: player, at: position) {
                number += 1
            }
        }
        return number
    }
    
    public func containsAtExactPosition(player: Player, at position: GameboardPosition) -> Bool {
        let (column, row) = (position.column, position.row)
        return positions[column][row] == player
    }
    
    // MARK: - Private
    
    private func initialPositions() -> [[Player?]] {
        var positions: [[Player?]] = []
        for _ in 0 ..< GameboardSize.columns {
            let rows = Array<Player?>(repeating: nil, count: GameboardSize.rows)
            positions.append(rows)
        }
        return positions
    }
}
