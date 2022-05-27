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
    
    init(winner: Player?, gameViewController: GameViewController) {
        self.winner = winner
        self.gameViewController = gameViewController
    }
    func begin() {
        if let winner = winner {
            switch winner {
            case .first:
                gameViewController?.infoLabel.text = "\(Game.shared.playerOneName) WON!"
                gameViewController?.infoLabel.textColor = .amazingBrandedBlueColor
                gameViewController?.playerOneScore += 1
            case .second:
                gameViewController?.infoLabel.text = "\(Game.shared.playerTwoName) WON!"
                gameViewController?.infoLabel.textColor = .amazingBrandedPinkColor
                gameViewController?.playerTwoScore += 1
            case .computer:
                gameViewController?.infoLabel.text = "COMPUTER WON!"
                gameViewController?.infoLabel.textColor = .amazingBrandedPinkColor
                gameViewController?.playerTwoScore += 1
            }
        } else {
            gameViewController?.infoLabel.text = "It's a draw!"
        }
        if let player = gameViewController?.playerToStart {
            gameViewController?.playerToStart = player.next
        }
    }
    
    func addMark(at position: GameboardPosition) {}
    
    func addAIMark() {
    }
}
