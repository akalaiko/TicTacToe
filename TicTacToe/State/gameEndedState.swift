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
        guard let gameViewController = gameViewController else { return }
        if let winner = winner {
            switch winner {
            case .first:
                gameViewController.infoLabel.text = "\(Game.shared.playerOneName.uppercased()) WON!"
                gameViewController.infoLabel.textColor = .amazingBrandedBlueColor
                gameViewController.playerOneScore += 1
            case .second:
                gameViewController.infoLabel.text = "\(Game.shared.playerTwoName.uppercased()) WON!"
                gameViewController.infoLabel.textColor = .amazingBrandedPinkColor
                gameViewController.playerTwoScore += 1
            case .computer:
                gameViewController.infoLabel.text = "COMPUTER WON!"
                gameViewController.infoLabel.textColor = .amazingBrandedPinkColor
                gameViewController.playerTwoScore += 1
            }
        } else {
            gameViewController.infoLabel.text = "It's a draw!"
        }
        
        guard gameViewController.playerOneScore < 5 && gameViewController.playerTwoScore < 5 else { return gameViewController.matchWon() }
        gameViewController.playerToStart = gameViewController.playerToStart.next
        gameViewController.nextRoundButton.isEnabled = true
    }
    
    func addMark(at position: GameboardPosition) {}
    
    func addAIMark() {
    }
}
