//
//  PlayerInputState.swift
//  TicTacToe
//
//  Created by Tim on 26.05.2022.
//

import Foundation

class PlayerInputState: GameState {
    
    var isCompleted: Bool = false
    var player: Player
    var gameViewController: GameViewController?
    weak var gameboard: Gameboard?
    weak var gameboardView: GameboardView?
    let markViewPrototype: MarkView
    lazy var referee = gameViewController?.referee
    
    init(player: Player,
         gameViewController: GameViewController,
         gameboard: Gameboard,
         gameboardView: GameboardView,
         markViewPrototype: MarkView) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.markViewPrototype = markViewPrototype
    }
    
    func begin() {
        
        switch player {
        case .first:
            gameViewController?.infoLabel.text = "\(Game.shared.playerOneName.uppercased()), it's your turn!"
            gameViewController?.infoLabel.textColor = .amazingBrandedBlueColor
        case .second:
            gameViewController?.infoLabel.text = "\(Game.shared.playerTwoName.uppercased()), it's your turn!"
            gameViewController?.infoLabel.textColor = .amazingBrandedPinkColor
        case .computer:
            gameViewController?.infoLabel.text = "COMPUTER's turn!"
            gameViewController?.infoLabel.textColor = .amazingBrandedPinkColor
        }
    }
    
    func addMark(at position: GameboardPosition) {
        guard let gameboardView = gameboardView,
              let gameboard = gameboard

        else {
            return
        }
        if Game.shared.stepMode == .fivePerMove {
            guard !gameboardView.temporaryMarksPositions.contains(position) else { return }
            let command = StepCommand(
                position: position,
                player: player,
                gameboard: gameboard,
                gameboardView: gameboardView,
                markViewPrototype: markViewPrototype
            )
            
            gameboardView.removeMarkView(at: position)
            gameboardView.placeMarkView(markViewPrototype.copy(), at: position)
            gameboardView.temporaryMarksPositions.append(position)
            gameViewController?.stepInvoker?.addCommand(command)
            
            
        } else {
            guard gameboardView.canPlaceMarkView(at: position) else { return }
            gameboard.setPlayer(player, at: position)
            gameboardView.placeMarkView(markViewPrototype.copy(), at: position)
        }
        if let commandsCount = gameViewController?.stepInvoker?.commands.count {
            if commandsCount % 5 == 0 { isCompleted = true }
        }
    }
    
    func addAIMark() {
        
        var positionOfNextMove: GameboardPosition?
        var numberOfMarksToWin: Int {
            switch Game.shared.fieldSize {
            case 3: return 3
            case 7: return 4
            default: return 4
            }
        }
        
        // let's try to get center
        
        if let gameboard = gameboard {
            let position = GameboardPosition(column: (GameboardSize.columns - 1) / 2, row: (GameboardSize.columns - 1) / 2)
            if !gameboard.containsAtExactPosition(player: .computer, at: position) {
                if let gameboardView = gameboardView {
                    if gameboardView.canPlaceMarkView(at: position) {
                        print("i'm gonna place mark in the middle")
                        addMark(at: position)
                        return
                    }
                }
            }
        }
        
        //setup winning combinations
        
        guard let referee = referee else { return }
        let winningCombinations = referee.winningCombinations
        
        // check for current combination possibilities
        
        var optimalCombinations: [Int : [[GameboardPosition]]] = [ : ]
        for number in 0..<numberOfMarksToWin {
            optimalCombinations[number] = []
        }
        for combination in winningCombinations {
            if let gameboard = gameboard {
                let number = gameboard.howManyTimesContains(player: .computer, at: combination)
                guard optimalCombinations[number] != nil else { return optimalCombinations[number] = [combination] }
                optimalCombinations[number]!.append(combination)
            }
        }
        
        // let's try to win
        
        if optimalCombinations[numberOfMarksToWin - 1] != [] {
            print("there might be a chance to win")
            for combination in optimalCombinations[numberOfMarksToWin - 1]! {
                for position in combination {
                    if let gameboard = gameboard {
                        if !gameboard.containsAtExactPosition(player: .computer, at: position) {
                            if let gameboardView = gameboardView {
                                if gameboardView.canPlaceMarkView(at: position) {
                                    print("i'm gonna place mark here: \(position), to complete this combination: \(combination)")
                                    addMark(at: position)
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
        // if ai can't win, let's move on to defence
        
        var opponentsCombinations: [Int : [[GameboardPosition]]] = [ : ]
        for number in 0..<numberOfMarksToWin {
            opponentsCombinations[number] = []
        }
        for combination in winningCombinations {
            if let gameboard = gameboard {
                let number = gameboard.howManyTimesContains(player: .first, at: combination)
                guard opponentsCombinations[number] != nil else { return opponentsCombinations[number] = [combination] }
                opponentsCombinations[number]!.append(combination)
            }
        }
        
        // let's see if we can block
        switch numberOfMarksToWin {
        case 4:
            var options: [GameboardPosition] = []
            if opponentsCombinations[3] != [] {
                print("there might be a chance to block")
                
                for combination in opponentsCombinations[3]! {
                    for position in combination {
                        if let gameboard = gameboard {
                            if !gameboard.containsAtExactPosition(player: .first, at: position) {
                                if let gameboardView = gameboardView {
                                    if gameboardView.canPlaceMarkView(at: position) {
                                        addMark(at: position)
                                        return
                                    }
                                }
                            }
                        }
                    }
                }
                if let position = positionOfNextMove {
                    addMark(at: position)
                }
            }
            
            // if we are here - we might be able to make us much stronger
            
            if optimalCombinations[2] != [] {
                print("there might be a chance to improve")
                for combination in optimalCombinations[2]! {
                    for position in combination {
                        if let gameboard = gameboard {
                            if !gameboard.containsAtExactPosition(player: .computer, at: position) {
                                if let gameboardView = gameboardView {
                                    if gameboardView.canPlaceMarkView(at: position) {
                                        options.append(position)
                                    }
                                }
                            }
                        }
                    }
                    if options.count == 2 {
                        print("improving")
                        addMark(at: options[1])
                        return
                    } else {
                        options = []
                    }
                }
            }
            
            // well, if there is nothing to improve here - let's check the defence
            
            if opponentsCombinations[2] != [] {
                print("there might be a chance to block")
                
                for combination in opponentsCombinations[2]! {
                    for position in combination {
                        if let gameboard = gameboard {
                            if !gameboard.containsAtExactPosition(player: .first, at: position) {
                                if let gameboardView = gameboardView {
                                    if gameboardView.canPlaceMarkView(at: position) {
                                        options.append(position)
                                    }
                                }
                            }
                        }
                    }
                    if options.count > 1 {
                        positionOfNextMove = options[options.count - 2]
                    } else if options.count > 0 {
                        positionOfNextMove = options[0]
                    }
                }
                if let position = positionOfNextMove {
                    addMark(at: position)
                }
            }
        case 3:
            var options: [GameboardPosition] = []
            if opponentsCombinations[2] != [] {
                print("there might be a chance to block")
                
                for combination in opponentsCombinations[2]! {
                    for position in combination {
                        if let gameboard = gameboard {
                            if !gameboard.containsAtExactPosition(player: .first, at: position) {
                                if let gameboardView = gameboardView {
                                    if gameboardView.canPlaceMarkView(at: position) {
                                        options.append(position)
                                    }
                                }
                            }
                        }
                    }
                    if options.count > 1 {
                        positionOfNextMove = options[1]
                    } else if options.count > 0 {
                        positionOfNextMove = options[0]
                    }
                }
                if let position = positionOfNextMove {
                    addMark(at: position)
                    return
                }
            }
        default: return
        }
    
        // this one makes 3*3 ai unbeatable
        // if there is nothing to block, for 3x3 let's take diagonals
        
//        if numberOfMarksToWin == 3 {
//            var diagonalPositions: [GameboardPosition] {
//                var array: [GameboardPosition] = []
//                array.append(GameboardPosition(column: 0, row: 0))
//                array.append(GameboardPosition(column: 0, row: GameboardSize.rows - 1))
//                array.append(GameboardPosition(column: GameboardSize.columns - 1, row: 0))
//                array.append(GameboardPosition(column: GameboardSize.columns - 1, row: GameboardSize.rows - 1))
//                return array
//            }
//            for position in diagonalPositions {
//                if let gameboard = gameboard {
//                    if !gameboard.containsAtExactPosition(player: .first, at: position) {
//                        if let gameboardView = gameboardView {
//                            if gameboardView.canPlaceMarkView(at: position) {
//                                addMark(at: position)
//                                return
//                            }
//                        }
//                    }
//                }
//            }
//        }
        
        // if there is nothing to block, try to improve our best line
        // (for future updates)
        
        // if there is no good move let's go randomly
        addAIMarkRandomly()
    }
    
    func addAIMarkRandomly() {
        while !isCompleted {
            let column = Int.random(in: 0 ..< GameboardSize.columns)
            let row = Int.random(in: 0 ..< GameboardSize.rows)
            let position = GameboardPosition(column: column, row: row)
            addMark(at: position)
        }
    }
}
