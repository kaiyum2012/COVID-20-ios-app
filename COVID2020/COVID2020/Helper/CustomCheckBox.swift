//
//  CustomCheckBox.swift
//  COVID2020
//
//  Created by Student on 2020-04-19.
//  Copyright © 2020 Kaiyum. All rights reserved.
//

// Reference
import UIKit

@IBDesignable class Checkbox: UIButton {

    private var tickLayer = CAShapeLayer()
    private var backLayer = CAShapeLayer()
    @IBInspectable var checkBoxColor: UIColor = UIColor.red
    @IBInspectable var insetEdge: CGFloat = 2 {
        didSet {
            self.layoutIfNeeded()
        }
    }
    @IBInspectable var lineWidth: CGFloat = 2
    @IBInspectable var tickLineWidth: CGFloat = 4
    var animationDuration = 0.25

    override var isSelected: Bool {
        didSet {
            self.updateState()
        }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    private func initialize() {
        let aRect = rectForSquare()
        backLayer.frame = aRect
        backLayer.lineWidth = lineWidth
        backLayer.fillColor = UIColor.clear.cgColor
        backLayer.strokeColor = checkBoxColor.cgColor
        layer.addSublayer(backLayer)
        backLayer.path = UIBezierPath(roundedRect: rectForSquare(), cornerRadius: 1).cgPath

        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: (aRect.size.width), bottom: 0, right: 0)
        self.addTarget(self, action: Selector(("pressed:")), for: UIControl.Event.touchUpInside)
        updateState()
    }

    func pressed(button: UIButton) {
        if self.isSelected {
            self.isSelected = false
        } else {
            self.isSelected = true
        }
    }

    private func updateState() {
        if isSelected {
            let boundingRect = rectForSquare()
            backLayer.lineWidth = lineWidth
            backLayer.path = UIBezierPath(roundedRect: boundingRect, cornerRadius: 1).cgPath
            backLayer.frame = boundingRect
            backLayer.strokeColor = checkBoxColor.cgColor
            let path = UIBezierPath()
            path.move(to: CGPoint(x: tickLineWidth + boundingRect.origin.x + (boundingRect.size.width*0.1), y: boundingRect.origin.y + boundingRect.size.height/2))
            path.addLine(to: CGPoint(x: boundingRect.origin.x + boundingRect.size.width/2, y: boundingRect.origin.y + (boundingRect.size.height * 0.9)))
            path.addLine(to: CGPoint(x: boundingRect.origin.x + (boundingRect.size.width * 1.2),
                                     y: boundingRect.origin.y + boundingRect.size.height * 0.2))
            tickLayer.fillColor = UIColor.clear.cgColor
            tickLayer.path = path.cgPath
            tickLayer.frame = bounds
            tickLayer.strokeColor = UIColor.black.cgColor
            tickLayer.lineWidth = tickLineWidth
            tickLayer.lineJoin = CAShapeLayerLineJoin.bevel
            layer.addSublayer(tickLayer)
            let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.duration = animationDuration
            pathAnimation.fromValue = NSNumber(value: 0.0)
            pathAnimation.toValue = NSNumber(value: 1.0)
            tickLayer.add(pathAnimation, forKey: "strokeEndAnimation")
        } else {
            tickLayer.removeFromSuperlayer()
        }
    }

    private func rectForSquare() ->CGRect {
        let rect = CGRect(x: insetEdge, y: insetEdge, width: (frame.size.width > frame.size.height ? frame.size.height : frame.size.width) - (4 * insetEdge) , height: (frame.size.width > frame.size.height ? frame.size.height : frame.size.width) - (4 * insetEdge))
        return rect
    }

    override func prepareForInterfaceBuilder() {
        initialize()
    }
}
