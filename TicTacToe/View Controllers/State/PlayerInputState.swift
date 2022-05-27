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
            gameViewController?.infoLabel.text = "PLAYER #1, it's your turn!"
        case .second:
            gameViewController?.infoLabel.text = "PLAYER #2, it's your turn!"
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
}
