//
//  StepInvoker.swift
//  TicTacToe
//
//  Created by Tim on 28.05.2022.
//

import Foundation

class StepInvoker {
    var commands: [StepCommand] = [] {
        didSet {
            guard let source = source else { return }
            if commands.count == 0 { source.gameboardView.boardBeforeMoves = source.gameboardView.markViewForPosition }
        }
    }
    weak var source: GameViewController?
    let referee: Referee?
    
    init(source: GameViewController, gameboard: Gameboard) {
        self.source = source
        self.referee = Referee(gameboard: gameboard)
    }
    
    func clear() {
        commands = []
    }
    
    func addCommand(_ command: StepCommand) {
        commands.append(command)
        executeCommandsIfNeeded()
    }
    
    func checkWinner() -> Bool {
        guard let referee = referee, let source = source else { return false }
        if let winner = referee.determineWinner() {
            source.currentState = gameEndedState(winner: winner, gameViewController: source)
            return true
        }
        return false
    }
    
    func executeCommandsIfNeeded() {
        guard let source = source else { return }

        if commands.count == 5 { cleanUp() }
        if commands.count == 10 {
            cleanUp()
            
            source.gameboardView.boardBeforeMoves = [:]
            
            for index in 0..<5 {
                guard !checkWinner() else { return clear()}
                commands[index].execute(delay: Double(index))
                guard !checkWinner() else { return clear()}
                commands[index + 5].execute(delay: Double(index) + 0.5)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.clear()
            }
        }
    }
    
    func cleanUp() {
        guard let source = source else { return }
        source.gameboardView.temporaryMarksPositions = []
        source.gameboardView.clear()
        for (key, mark) in source.gameboardView.boardBeforeMoves { source.gameboardView.placeMarkView(mark, at: key) }
    }
}
