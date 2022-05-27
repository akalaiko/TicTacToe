//
//  ComputerInputState.swift
//  TicTacToe
//
//  Created by Tim on 27.05.2022.
//

import Foundation

class ComputerInputState: GameState {
    
    var isCompleted: Bool = false
    var player: Player
    weak var gameViewController: GameViewController?
    weak var gameboard: Gameboard?
    weak var gameboardView: GameboardView?
    let markViewPrototype: MarkView
    
    init(player: Player,
         gameViewController: GameViewController,
         gameboard: Gameboard,
         gameboardView: GameboardView,
         markViewPrototype: MarkView) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.markViewPrototype = markViewPrototype
    }
    
    func begin() {
        switch player {
        case .first:
            gameViewController?.infoLabel.text = "\(Game.shared.playerOneName), it's your turn!"
            gameViewController?.infoLabel.textColor = .amazingBrandedBlueColor
        case .computer:
            gameViewController?.infoLabel.text = "COMPUTER's turn!"
            gameViewController?.infoLabel.textColor = .amazingBrandedPinkColor
        default: return
        }
    }
    
    func addMark(at position: GameboardPosition) {
        guard let gameboardView = gameboardView,
                  gameboardView.canPlaceMarkView(at: position) else {
            return
        }
        gameboard?.setPlayer(player, at: position)
        gameboardView.placeMarkView(markViewPrototype.copy(), at: position)
        isCompleted = true
    }
    
    func addAIMark() {
        var markIsPlaced = false
        repeat {
            let column = Int.random(in: 0 ..< GameboardSize.columns)
            let row = Int.random(in: 0 ..< GameboardSize.rows)
            let position = GameboardPosition(column: column, row: row)
            addMark(at: position)
            markIsPlaced = true
        } while markIsPlaced == false
        isCompleted = true
    }
}
