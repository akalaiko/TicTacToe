//
//  GameState.swift
//  TicTacToe
//
//  Created by Tim on 26.05.2022.
//

import Foundation

protocol GameState {
    var isCompleted: Bool { get }
    
    func begin()
    func addMark(at position: GameboardPosition)
    func addAIMark()
}
