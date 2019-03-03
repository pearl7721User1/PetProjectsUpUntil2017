//
//  LayoutEditingSizeControl.swift
//  ReplaceScrollViewTest
//
//  Created by SeoGiwon on 04/09/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

/// It defines functions to be called when the user interaction on a LayoutEditingSizeControl occurs
protocol LayoutEditingSizeControlProtocol {
    
    /**
     - parameters:
        - sizeControl: the size control that wants to move
        - delta: the point that the size control wants to move
        - currentCenterOffset: the difference between the point that the size control is currently placed
     upon and the size control's center value
     */
    func shouldMove(sizeControl: LayoutEditingSizeControl, delta: CGPoint, currentCenterOffset: CGPoint) -> Bool

    /**
     - parameters:
        - sizeControl: the size control that has moved
        - delta: the point that the size control has moved
     */
    func didMove(sizeControl: LayoutEditingSizeControl, delta: CGPoint)
}

class LayoutEditingSizeControl: UIView {
    
    enum ControlType {
        case vertical, horizontal, both
    }
    
    var controlType = ControlType.vertical
    
    init(controlType: ControlType) {
        self.controlType = controlType
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private var viewCenterXConstraint = NSLayoutConstraint()
    private var viewCenterYConstraint = NSLayoutConstraint()
    
    var delegate: LayoutEditingSizeControlProtocol?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.backgroundColor = UIColor.init(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
        
        let pg = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(pg)
        
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    /**
     Bind the size control's anchors to the given superview's. It is centered off from the given
     centerOff parameter.
    */
    func setupConstraints(superview: UIView, size: CGSize, centerOff: CGPoint) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        
        viewCenterXConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy:.equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: centerOff.x)
        viewCenterYConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy:.equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: centerOff.y)

        NSLayoutConstraint.activate([viewCenterXConstraint, viewCenterYConstraint])
        
    }
    
    /// Update the position(constraints) of the size control
    func update(offsetDelta: CGPoint) {
        
        viewCenterXConstraint.constant += offsetDelta.x
        viewCenterYConstraint.constant += offsetDelta.y
        
    }

    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self)
        var delta = CGPoint.zero
        
        guard let delegate = delegate else {
            print("delegate for LayoutEditingSizeControl does not exist")
            return
        }
        
        // size control's delta value is trimmed depending on the control type
        switch controlType {
            case .vertical: delta = CGPoint(x: translation.x, y: 0)
            case .horizontal: delta = CGPoint(x: 0, y: translation.y)
            case .both: delta = translation
        }
        
        // ask the delegate if the size control's position update is allowed
        if delegate.shouldMove(sizeControl: self, delta: delta, currentCenterOffset:
            CGPoint(x: viewCenterXConstraint.constant, y: viewCenterYConstraint.constant))
        {
            update(offsetDelta: delta)
            delegate.didMove(sizeControl: self, delta: delta)
        }
        
        sender.setTranslation(CGPoint.zero, in: self)
        self.layoutIfNeeded()
    }
}
