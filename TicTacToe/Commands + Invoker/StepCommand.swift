//
//  StepCommand.swift
//  TicTacToe
//
//  Created by Tim on 28.05.2022.
//

import Foundation

protocol Command: AnyObject {
    func execute(delay: Double)
}

class StepCommand: Command {
    
    private var player: Player
    private var position: GameboardPosition
    private var markViewPrototype: MarkView
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    private var referee: Referee?
    
    
    init(position: GameboardPosition, player: Player, gameboard: Gameboard, gameboardView: GameboardView,
         markViewPrototype: MarkView) {
        self.position = position
        self.player = player
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.markViewPrototype = markViewPrototype
        self.referee = Referee(gameboard: gameboard)
    }
    
    func execute(delay: Double) {
        guard let gameboardView = gameboardView, let gameboard = gameboard else { return }
        if !gameboard.containsAnything(at: position) {
            gameboard.setPlayer(self.player, at: self.position)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay ) {
                gameboardView.placeMarkView(self.markViewPrototype.copy(), at: self.position)
            }
        } else {
            gameboard.setPlayer(self.player, at: self.position)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay ) {
                gameboardView.removeMarkView(at: self.position)
                gameboardView.placeMarkView(self.markViewPrototype.copy(), at: self.position)
            }
            
        }
    }
}
