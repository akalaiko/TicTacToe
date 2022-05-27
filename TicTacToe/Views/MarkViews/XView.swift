//
//  XView.swift
//  XO-game
//
//  Created by Evgeny Kireev on 26/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

public class XView: MarkView {
    
    internal override func updateMark() {
        super.updateMark()
        let imageView = UIImageView(frame: CGRect(x: bounds.width * 0.1, y: bounds.height * 0.1, width: bounds.width * 0.8, height: bounds.height * 0.8))
        imageView.image = UIImage(named: "blueX")
        addSubview(imageView)
    }
}
