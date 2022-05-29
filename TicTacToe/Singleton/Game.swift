//
//  Game.swift
//  TicTacToe
//
//  Created by Tim on 27.05.2022.
//

import Foundation

class Game {
    
    static let shared = Game()
    
    var mode: Mode = .twoPlayers
    var stepMode: StepMode = .onePerMove
    var fieldSize: Int = 3 {
        didSet {
            GameboardSize.columns = fieldSize
            GameboardSize.rows = fieldSize
        }
    }
    var playerOneName: String = "PLAYER #1"
    var playerTwoName: String = "PLAYER #2"
    
    private init() {}
    
    func description() -> String{
        return "fieldSize: \(fieldSize), mode: \(mode), stepMode: \(stepMode), players: \(playerOneName), \(playerTwoName)"
    }
    
}

