//
//  StepInvoker.swift
//  TicTacToe
//
//  Created by Tim on 28.05.2022.
//

import Foundation

class StepInvoker {
    private var commands: [StepCommand] = []
    {
        didSet {
            if commandsCount() == 0 {
                source?.gameboardView.boardBeforeMoves = (source?.gameboardView.markViewForPosition)!
            }
        }
    }
    weak var source: GameViewController?
    let referee: Referee?
    
    init(source: GameViewController, gameboard: Gameboard) {
        self.source = source
        self.referee = Referee(gameboard: gameboard)
    }
    
    func commandsCount() -> Int {
        commands.count
    }
    
    func clear() {
        commands = []
    }
    
    func addCommand(_ command: StepCommand) {
        commands.append(command)
        executeCommandsIfNeeded()
    }
    
    func checkWinner() -> Bool {
        guard
            let referee = referee,
            let source = source
        else { return false }

        if let winner = referee.determineWinner() {
            source.currentState = gameEndedState(
                winner: winner,
                gameViewController: source
            )
            return true
        }
        return false
    }
    
    func executeCommandsIfNeeded() {
        guard let source = source else { return }
        let temporaryMarksPositions = source.gameboardView.temporaryMarksPositions
        

        if commands.count == 5 {
//            for position in temporaryMarksPositions { source.gameboardView.removeMarkView(at: position) }
            source.gameboardView.temporaryMarksPositions = []
            source.gameboardView.clear()

            for (key, mark) in source.gameboardView.boardBeforeMoves {
                source.gameboardView.placeMarkView(mark, at: key)
            }
        }
        
        if commands.count == 10 {
//            source?.restartButton.isHidden = true
            source.gameboardView.clear()
            for position in temporaryMarksPositions { source.gameboardView.removeMarkView(at: position) }
            source.gameboardView.temporaryMarksPositions = []
            
//            source.gameboardView.clear()
            for (key, mark) in source.gameboardView.boardBeforeMoves {
                source.gameboardView.placeMarkView(mark, at: key)
            }
            
            source.gameboardView.boardBeforeMoves = [:]
            
            for index in 0..<Int(commands.count / 2) {
//                if self.checkWinner() {
//                    self.commands = []
//                    return
//                }
                
                commands[index].execute(delay: Double(index))
                if self.checkWinner() {
                    self.commands = []
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index)) {
//                        self.source?.restartButton.isHidden = false
                    }
                    return
                }
                
                self.commands[index + 5].execute(delay: Double(index) + 0.5)
                if self.checkWinner() {
                    self.commands = []
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) + 0.5) {
//                        self.source?.restartButton.isHidden = false
                    }
                    return
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                self.source?.restartButton.isHidden = false
                self.commands = []
//                source.gameboardView.boardBeforeMoves = source.gameboardView.markViewForPosition
//                print(source.gameboardView.boardBeforeMoves)
                self.source?.setFirstPlayerStep()
            }
            
        }
    }
}
