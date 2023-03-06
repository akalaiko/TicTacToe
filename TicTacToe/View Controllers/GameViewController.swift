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
            playerOneName.text = Game.shared.playerOneName.uppercased()
        }
    }
    @IBOutlet var playerOneScoreLabel: UILabel!
    @IBOutlet var playerOneCurrentMark: UIImageView!
    @IBOutlet var playerOneAvatar: AvatarImage!{
        didSet {
            playerOneAvatar.image = UIImage(named: "\(Int.random(in: 1...12))")
        }
    }
    @IBOutlet var playerTwoAvatar: AvatarImage!{
        didSet {
            if Game.shared.playerTwoName == "COMPUTER" {
                playerTwoAvatar.image = UIImage(named: "robot")
            } else {
                playerTwoAvatar.image = UIImage(named: "\(Int.random(in: 1...12))")
            }
        }
    }
    @IBOutlet var playerTwoName: UILabel!{
        didSet {
            playerTwoName.text = Game.shared.playerTwoName.uppercased()
        }
    }
    @IBOutlet var playerTwoScoreLabel: UILabel!
    @IBOutlet var playerTwoCurrentMark: UIImageView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var nextRoundButton: UIButton!
    
    @IBAction func backToMainButtonPressed(_ sender: Any) {
        let ac = UIAlertController(title: "Are you sure?", message: "Do you really want to exit?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: exitToMainMenu))
        ac.addAction(UIAlertAction(title: "Nope", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    @IBAction func restartMatchButtonPressed(_ sender: Any) {
        let ac = UIAlertController(title: "Are you sure?", message: "Do you really want to restart the whole match?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: restartTheMatch))
        ac.addAction(UIAlertAction(title: "Nope", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    @IBAction func nextRoundButtonPressed(_ sender: Any) {
        setFirstPlayerStep()
        gameboardView.clear()
        gameboardView.boardBeforeMoves = [:]
        gameboard.clear()
        stepInvoker?.clear()
    }
    
    var stepInvoker: StepInvoker?
    private let gameboard = Gameboard()
    lazy var referee = Referee(gameboard: gameboard)
    var currentState: GameState! {
        didSet {
            aiNeedsToThink()
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
        welcomeMessage()
        self.stepInvoker = StepInvoker(source: self, gameboard: gameboard)
        setFirstPlayerStep()
        setGameboardViewInitialState()
        gameboardView.boardBeforeMoves = gameboardView.markViewForPosition
    }
    
    public func matchWon() {
        let winner = playerOneScore == 5 ? playerOneName.text?.uppercased() : playerTwoName.text?.uppercased()
        let ac = UIAlertController(title: "Game over", message: "THE WINNER IS: \(winner ?? "") \n Do you want to play one more time?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: restartTheMatch))
        ac.addAction(UIAlertAction(title: "No", style: .default, handler: exitToMainMenu))
        present(ac, animated: true)
    }
    
    private func setGameboardViewInitialState() {
        switch playerToStart {
        case .first, .second:
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
        case .computer: aiNeedsToThink()
        }
    }
    
    private func setFirstPlayerStep() {
        currentState = PlayerInputState(
            player: playerToStart,
            gameViewController: self,
            gameboard: gameboard,
            gameboardView: gameboardView,
            markViewPrototype: playerToStart.markViewPrototype
        )
        nextRoundButton.isEnabled = false
        
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
    
    private func goToNextState() {
        if let winner = referee.determineWinner() {
            currentState = gameEndedState(winner: winner, gameViewController: self)
            return
        }
        
        switch Game.shared.stepMode {
        case .onePerMove:
            guard !checkIfNoMoreMoves() else { return currentState = gameEndedState(winner: nil, gameViewController: self) }
            setPlayer()
        case .fivePerMove:
            guard let stepInvoker = stepInvoker else { return }
            if stepInvoker.commands.count % 5 == 0 { setPlayer() }
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
    private func aiNeedsToThink() {
        currentState.begin()
        switch Game.shared.stepMode {
        case .fivePerMove:
            guard let stepInvoker = stepInvoker else { return }
            
            let delay: Double = stepInvoker.commands.count < 6 ? 3 : 5
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: { [self] in
                for _ in 0..<5 { aiMove() }
            })
        case .onePerMove: aiMove()
        }
    }
    
    private func setPlayer() {
        if let playerInputState = currentState as? PlayerInputState {
            let player = playerInputState.player.next
            currentState = PlayerInputState(player: player,
                                            gameViewController: self,
                                            gameboard: gameboard,
                                            gameboardView: gameboardView,
                                            markViewPrototype: player.markViewPrototype)
        }
    }
    
    private func exitToMainMenu(action: UIAlertAction! = nil) {
        navigationController?.popViewController(animated: true)
    }
    
    private func welcomeMessage() {
        let ac = UIAlertController(title: "Let the game begin", message: "First player to get 5 points wins the match. \n Good luck!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Got it!", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    private func restartTheMatch(action: UIAlertAction! = nil) {
        playerOneScore = 0
        playerTwoScore = 0
        playerToStart = .first
        setFirstPlayerStep()
        gameboardView.clear()
        gameboardView.boardBeforeMoves = [:]
        gameboard.clear()
        stepInvoker?.clear()
    }
}
