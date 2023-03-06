//
//  Game.swift
//  TicTacToe
//
//  Created by Tim on 27.05.2022.
//

import Foundation

final class Game {
    
    static let shared = Game()
    private init() {}
    
    var mode: Mode = .twoPlayers
    var stepMode: StepMode = .onePerMove
    var fieldSize = 3 {
        didSet {
            GameboardSize.columns = fieldSize
            GameboardSize.rows = fieldSize
        }
    }
    var playerOneName = "PLAYER #1"
    var playerTwoName = "PLAYER #2"
    
    func description() -> String {
        return "fieldSize: \(fieldSize), mode: \(mode), stepMode: \(stepMode), players: \(playerOneName), \(playerTwoName)"
    }
    
}

