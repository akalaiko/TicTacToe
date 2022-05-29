//
//  AvatarView.swift
//  TicTacToe
//
//  Created by Tim on 24.05.2022.
//

import UIKit

class AvatarImage: UIImageView {
    @IBInspectable var borderColor: UIColor = .amazingBrandedBlueColor
    @IBInspectable var borderWidth: CGFloat = 3
    
    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.height / 8
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}
