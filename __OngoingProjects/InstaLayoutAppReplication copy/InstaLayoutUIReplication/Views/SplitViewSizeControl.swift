//
//  SplitViewSizeControl.swift
//  ReplaceScrollViewTest
//
//  Created by SeoGiwon on 04/09/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

protocol SplitViewSizeControlProtocol {
    func shouldMove(sizeControl: SplitViewSizeControl, newCenterOff: CGPoint) -> Bool
    func didMove(sizeControl: SplitViewSizeControl, delta: CGPoint)
}

class SplitViewSizeControl: UIView {
    
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
    
    var delegate: SplitViewSizeControlProtocol?
    
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
    
    func setupSuperviewConstraints(superview: UIView, size: CGSize, centerOff: CGPoint) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        
        viewCenterXConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy:.equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: centerOff.x)
        viewCenterYConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy:.equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: centerOff.y)

        NSLayoutConstraint.activate([viewCenterXConstraint, viewCenterYConstraint])
        
    }
    
    func update(offsetDelta: CGPoint) {
        
        viewCenterXConstraint.constant += offsetDelta.x
        viewCenterYConstraint.constant += offsetDelta.y
        
    }

    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        
        
        if controlType == .horizontal {
            
            if let delegate = delegate {
                
                if delegate.shouldMove(sizeControl: self, newCenterOff:
                    CGPoint(x: viewCenterXConstraint.constant,
                            y: viewCenterYConstraint.constant + translation.y)) {
                    
                    update(offsetDelta: CGPoint(x: 0, y: translation.y))
                    //viewCenterYConstraint.constant = viewCenterYConstraint.constant + translation.y
                    delegate.didMove(sizeControl: self, delta: CGPoint(x: 0, y: translation.y))
                }
                
            }
            
        } else if controlType == .vertical {
            
            if let delegate = delegate {
                
                if delegate.shouldMove(sizeControl: self, newCenterOff:
                    CGPoint(x: viewCenterXConstraint.constant + translation.x,
                            y: viewCenterYConstraint.constant)) {
                    
                    update(offsetDelta: CGPoint(x: translation.x, y: 0))
                    //viewCenterXConstraint.constant = viewCenterXConstraint.constant + translation.x
                    delegate.didMove(sizeControl: self, delta: CGPoint(x: translation.x, y: 0))
                }
                
            }
            
        } else if controlType == .both {
            
            if let delegate = delegate {
                
                if delegate.shouldMove(sizeControl: self, newCenterOff:
                    CGPoint(x: viewCenterXConstraint.constant + translation.x,
                            y: viewCenterYConstraint.constant + translation.y)) {
                    
                    update(offsetDelta: translation)
                    //viewCenterXConstraint.constant = viewCenterXConstraint.constant + translation.x
                    //viewCenterYConstraint.constant = viewCenterYConstraint.constant + translation.y
                    delegate.didMove(sizeControl: self, delta: CGPoint(x: translation.x, y: translation.y))
                }
            }
        }
        
        sender.setTranslation(CGPoint.zero, in: self)

        
        self.layoutIfNeeded()
    }
}
