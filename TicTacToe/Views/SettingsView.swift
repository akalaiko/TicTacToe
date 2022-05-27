//
//  SettingsView.swift
//  TicTacToe
//
//  Created by Tim on 27.05.2022.
//

import UIKit

protocol SettingsViewDelegate: AnyObject {
    func goToGame()
}

class SettingsView: UIView, SettingsViewDelegate {
    
    weak var delegate: SettingsViewDelegate?
    @IBOutlet var contentView: UIView!
    @IBOutlet var playerOneNameTextField: UITextField!
    @IBOutlet var playerTwoNameTextField: UITextField!
    @IBOutlet var fieldSizeSegmentedControl: UISegmentedControl!
    @IBOutlet var markPlacementModeSegmentedControl: UISegmentedControl!
    @IBAction func playButtonPressed(_ sender: UIButton) {
        goToGame()
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SettingsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func goToGame() {
        delegate?.goToGame()
    }
}
