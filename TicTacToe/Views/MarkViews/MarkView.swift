//
//  MarkView.swift
//  XO-game
//
//  Created by Evgeny Kireev on 26/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

public class MarkView: UIView {
    
    // MARK: - Properties
    
    public var lineColor: UIColor = .black
    public var lineWidth: CGFloat = 7
    public var textColor: UIColor = .red {
        didSet { label.textColor = textColor }
    }
    
    public var turnNumbers: [Int] = [] {
        didSet {
            label.text = turnNumbers.map { String($0) }.joined(separator: ",")
        }
    }
    
    internal private(set) lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = lineColor.cgColor
        self.layer.addSublayer(shapeLayer)
        return shapeLayer
    }()
    
    internal private(set) lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 0.1 * bounds.height))
        label.textColor = textColor
        label.textAlignment = .right
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal,
                           toItem: self, attribute: .top, multiplier: 1, constant: 4).isActive = true
        NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal,
                           toItem: self, attribute: .height, multiplier: 0.1, constant: 0).isActive = true
        NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal,
                           toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal,
                           toItem: label, attribute: .trailing, multiplier: 1, constant: 4).isActive = true
        
        return label
    }()
    
    // MARK: - Init
    
    public init() {
        super.init(frame: CGRect(origin: .zero,
                                 size: CGSize(width: 90, height: 90)))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UIView
    
    public final override func layoutSubviews() {
        super.layoutSubviews()
        updateLabel()
        updateShapeLayer()
    }
    
    public override var frame: CGRect {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    public override var bounds: CGRect {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    // MARK: - Methods
    
    public func animateIn(duration: TimeInterval = 0.5,
                          completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0.0
        animation.toValue = 1.0
        shapeLayer.add(animation, forKey: nil)
        CATransaction.commit()
    }
    
    public func animateOut(duration: TimeInterval = 0.5,
                           completion: @escaping () -> Void) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = duration
        animation.fromValue = 1.0
        animation.toValue = 0.0
        shapeLayer.add(animation, forKey: nil)
        CATransaction.commit()
    }
    
    // MARK: - UI
    
    private final func updateLabel() {
        let size = 0.1 * bounds.height
        label.font = UIFont.systemFont(ofSize: size, weight: .thin)
    }
    
    // MARK: - Template methods
    
    internal func updateShapeLayer() {
        // meant for subclasses to override
    }
}
