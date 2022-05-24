//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Tim on 25.05.2022.
//

import UIKit

final class GameViewController: UIViewController {
    
    @IBOutlet var gameboardView: GameboardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            self.gameboardView.placeMarkView(XView(), at: position)
        }
    }
}
