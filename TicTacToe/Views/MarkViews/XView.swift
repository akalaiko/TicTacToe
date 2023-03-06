//
//  XView.swift
//  TicTacToe
//
//  Created by Tim on 27.05.2022.
//

import UIKit

final class XView: MarkView {
    
    internal override func updateMark() {
        super.updateMark()
        let imageView = UIImageView(frame: CGRect(x: bounds.width * 0.1, y: bounds.height * 0.1, width: bounds.width * 0.8, height: bounds.height * 0.8))
        imageView.image = UIImage(named: "blueX")
        addSubview(imageView)
    }
}
