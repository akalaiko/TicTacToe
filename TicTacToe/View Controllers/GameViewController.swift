//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Tim on 25.05.2022.
//

import UIKit

final class GameViewController: UIViewController {
    
    @IBOutlet var playerOneName: UILabel! {
        didSet {
            playerOneName.text = Game.shared.playerOneName
        }
    }
    @IBOutlet var playerOneScoreLabel: UILabel!
    @IBOutlet var playerOneCurrentMark: UIImageView!
    @IBOutlet var playerTwoName: UILabel!{
        didSet {
            playerTwoName.text = Game.shared.playerTwoName
        }
    }
    @IBOutlet var playerTwoScoreLabel: UILabel!
    @IBOutlet var playerTwoCurrentMark: UIImageView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var gameboardView: GameboardView!
    
    @IBAction func backToMainButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func restartMatchButtonPressed(_ sender: Any) {
        
    }
    @IBAction func nextRoundButtonPressed(_ sender: Any) {
        gameboard.clear()
        gameboardView.clear()
        goToFirstState()
    }
    
    var stepInvoker: StepInvoker?
    private let gameboard = Gameboard()
    lazy var referee = Referee(gameboard: gameboard)
    var currentState: GameState! {
        didSet {
            currentState.begin()
            switch Game.shared.stepMode {
            case .fivePerMove:
                for _ in 0..<5 {
                    aiMove()
                }
            case .onePerMove:
                aiMove()
            }
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
        self.stepInvoker = StepInvoker(source: self, gameboard: gameboard)
        goToFirstState()
        setGameboardViewInitialState()
        gameboardView.boardBeforeMoves = gameboardView.markViewForPosition
    }
    
    private func setGameboardViewInitialState() {
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            if let playerInputState = self.currentState as? PlayerInputState {
                if playerInputState.player != .computer {
                    self.currentState.addMark(at: position)
                    if self.currentState.isCompleted {
                        self.goToNextState()
                    }
                }
            }
        }
    }
    
    
    func setFirstPlayerStep() {
        currentState = PlayerInputState(
            player: playerToStart,
            gameViewController: self,
            gameboard: gameboard,
            gameboardView: gameboardView,
            markViewPrototype: playerToStart.markViewPrototype
        )
    }
    
    private func checkIfNoMoreMoves() -> Bool {
        var result = true
        gameboard.positions.forEach { column in
            if column.contains(nil) {
                result = false
            }
        }
        return result
    }
    
    private func goToFirstState() {
        let player = playerToStart
        currentState = PlayerInputState(player: player,
                                        gameViewController: self,
                                        gameboard: gameboard,
                                        gameboardView: gameboardView,
                                        markViewPrototype: player.markViewPrototype)
        gameboardView.clear()
        gameboard.clear()
    }
    
    private func goToNextState() {
        if let winner = referee.determineWinner() {
            currentState = gameEndedState(winner: winner, gameViewController: self)
            return
        }
        
        switch Game.shared.stepMode {
        case .onePerMove:
            guard !checkIfNoMoreMoves() else { return currentState = gameEndedState(winner: nil, gameViewController: self) }
            
            if let playerInputState = currentState as? PlayerInputState {
                let player = playerInputState.player.next
                currentState = PlayerInputState(player: player,
                                                gameViewController: self,
                                                gameboard: gameboard,
                                                gameboardView: gameboardView,
                                                markViewPrototype: player.markViewPrototype)
            }
        case .fivePerMove:
            guard let stepInvoker = stepInvoker else { return }
            if let playerInputState = currentState as? PlayerInputState {
                if stepInvoker.commandsCount() % 5 == 0 {
                    let player = playerInputState.player.next
                    currentState = PlayerInputState(player: player,
                                                    gameViewController: self,
                                                    gameboard: gameboard,
                                                    gameboardView: gameboardView,
                                                    markViewPrototype: player.markViewPrototype)
                }
            }
        }
    }
    
    private func aiMove() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            if let playerInputState = self.currentState as? PlayerInputState {
                if playerInputState.player == .computer {
                    self.currentState.addAIMark()
                    if self.currentState.isCompleted {
                        self.goToNextState()
                    }
                }
            }
        })
    }
}
