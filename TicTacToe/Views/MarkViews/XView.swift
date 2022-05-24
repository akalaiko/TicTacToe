//
//  XView.swift
//  XO-game
//
//  Created by Evgeny Kireev on 26/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

public class XView: MarkView {
    
    internal override func updateShapeLayer() {
        super.updateShapeLayer()
        let imageView = UIImageView(frame: CGRect(x: bounds.width * 0.1, y: bounds.height * 0.1, width: bounds.width * 0.8, height: bounds.height * 0.8))
        imageView.image = UIImage(named: "blueX")
        addSubview(imageView)
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 0.25 * bounds.width, y: 0.25 * bounds.height))
//        path.addLine(to: CGPoint(x: 0.75 * bounds.width, y: 0.75 * bounds.height))
//        path.move(to: CGPoint(x: 0.75 * bounds.width, y: 0.25 * bounds.height))
//        path.addLine(to: CGPoint(x: 0.25 * bounds.width, y: 0.75 * bounds.height))
//        shapeLayer.path = path.cgPath
    }
}
