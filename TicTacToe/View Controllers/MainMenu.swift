//
//  ViewController.swift
//  TicTacToe
//
//  Created by Tim on 24.05.2022.
//

import UIKit

class MainMenu: UIViewController, SettingsViewDelegate {
    
    
    @IBOutlet var settingsView: SettingsView!
    
    @IBAction func playButtonAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            Game.shared.mode = .twoPlayers
            settingsView.playerTwoNameTextField.placeholder = "PLAYER #2"
            settingsView.playerTwoNameTextField.isEnabled = true
            settingsView.isHidden = false
        case 1:
            Game.shared.mode = .vsComputer
            settingsView.playerTwoNameTextField.placeholder = "COMPUTER"
            settingsView.playerTwoNameTextField.isEnabled = false
            settingsView.isHidden = false
        default :
            return
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        settingsView.playerOneNameTextField.text = nil
        settingsView.playerTwoNameTextField.text = nil
        settingsView.playerTwoNameTextField.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsView.delegate = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGame" {
            switch settingsView.fieldSizeSegmentedControl.selectedSegmentIndex {
            case 0: Game.shared.fieldSize = 3
            case 1: Game.shared.fieldSize = 7
            default: Game.shared.fieldSize = 7
            }
            
            switch settingsView.markPlacementModeSegmentedControl.selectedSegmentIndex {
            case 0: Game.shared.stepMode = .onePerMove
            case 1: Game.shared.stepMode = .fivePerMove
            default: Game.shared.stepMode = .onePerMove
            }
            
            if let text = settingsView.playerOneNameTextField.text {
                Game.shared.playerOneName = text == "" ? settingsView.playerOneNameTextField.placeholder ?? "Player #1" : text
            }
            if let text = settingsView.playerTwoNameTextField.text {
                Game.shared.playerTwoName = text == "" ? settingsView.playerTwoNameTextField.placeholder ?? "Player #2" : text
            }
        }
    }
    
    func goToGame() {
        settingsView.isHidden = true
        performSegue(withIdentifier: "goToGame", sender: nil)
    }


}

