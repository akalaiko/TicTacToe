//
//  Player.swift
//  TicTacToe
//
//  Created by Tim on 25.05.2022.
//

import Foundation

enum Player: CaseIterable {
    case first
    case second
    
    var next: Player {
        switch self {
        case .first: return .second
        case .second: return .first
        }
    }
}
