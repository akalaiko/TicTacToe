//
//  PlayerInputState.swift
//  TicTacToe
//
//  Created by Tim on 26.05.2022.
//

import Foundation

class PlayerInputState: GameState {
    
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
        case .second:
            gameViewController?.infoLabel.text = "\(Game.shared.playerTwoName), it's your turn!"
            gameViewController?.infoLabel.textColor = .amazingBrandedPinkColor
//        default: return
        case .computer:
            gameViewController?.infoLabel.text = "COMPUTER's turn!"
            gameViewController?.infoLabel.textColor = .amazingBrandedPinkColor
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
        while !isCompleted {
            let column = Int.random(in: 0 ..< GameboardSize.columns)
            let row = Int.random(in: 0 ..< GameboardSize.rows)
            let position = GameboardPosition(column: column, row: row)
//            print("trying to put mark at: \(position)")
            addMark(at: position)
//            print("success")
        }
//        print("we are done here")
        isCompleted = true
    }
}
