//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Tim on 25.05.2022.
//

import UIKit

final class GameViewController: UIViewController {
    
    @IBOutlet var playerOneName: UILabel!
    @IBOutlet var playerOneScoreLabel: UILabel!
    @IBOutlet var playerOneCurrentMark: UIImageView!
    @IBOutlet var playerTwoName: UILabel!
    @IBOutlet var playerTwoScoreLabel: UILabel!
    @IBOutlet var playerTwoCurrentMark: UIImageView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var gameboardView: GameboardView!
    
    @IBAction func backToMainButtonPressed(_ sender: Any) {
    }
    @IBAction func restartMatchButtonPressed(_ sender: Any) {
        
    }
    @IBAction func nextRoundButtonPressed(_ sender: Any) {
        gameboard.clear()
        gameboardView.clear()
        goToFirstState()
    }
    
    private let gameboard = Gameboard()
    private lazy var referee = Referee(gameboard: gameboard)
    private var currentState: GameState! {
        didSet {
            currentState.begin()
        }
    }
    var playerOneScore = 0 {
        didSet {
            playerOneScoreLabel.text = "\(playerOneScore)"
        }
    }
    var playerTwoScore = 0 {
        didSet {
            playerTwoScoreLabel.text = "\(playerTwoScore)"
        }
    }
    var playerToStart: Player = .first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goToFirstState()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            self.currentState.addMark(at: position)
            if self.currentState.isCompleted {
                self.goToNextState()
            }
        }
    }
    
    private func goToFirstState() {
        let player = playerToStart
        currentState = PlayerInputState(player: player,
                                        gameViewController: self,
                                        gameboard: gameboard,
                                        gameboardView: gameboardView,
                                        markViewPrototype: player.markViewPrototype)
    }
    
    private func goToNextState() {
        if let winner = referee.determineWinner() {
            currentState = gameEndedState(winner: winner, gameViewController: self)
            return
        }
        
        if let playerInputState = currentState as? PlayerInputState {
            let player = playerInputState.player.next
            currentState = PlayerInputState(player: player,
                                            gameViewController: self,
                                            gameboard: gameboard,
                                            gameboardView: gameboardView, markViewPrototype: player.markViewPrototype)
        }
    }
}
