//
//  gameEndedState.swift
//  TicTacToe
//
//  Created by Tim on 26.05.2022.
//

import Foundation

class gameEndedState: GameState {
    let isCompleted: Bool = false
    let winner: Player?
    weak var gameViewController: GameViewController?
    
    init(winner: Player, gameViewController: GameViewController) {
        self.winner = winner
        self.gameViewController = gameViewController
    }
    func begin() {
        if let winner = winner {
            switch winner {
            case .first:
                gameViewController?.infoLabel.text = "PLAYER #1 WON!"
                gameViewController?.playerOneScore += 1
            case .second:
                gameViewController?.infoLabel.text = "PLAYER #2 WON!"
                gameViewController?.playerTwoScore += 1
            }
            if let player = gameViewController?.playerToStart {
                gameViewController?.playerToStart = player.next
            }
        } else {
            gameViewController?.infoLabel.text = "It's a draw!"
        }
    }
    
    func addMark(at position: GameboardPosition) {}
}
