//
//  ResizeControl.swift
//  CropViewSwiftTesting
//
//  Created by SeoGiwon on 1/22/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

protocol ResizeControlViewDelegate {
    
    func resizeControlViewDidBeginResizing(resizeControlView: ResizeControl)
    func resizeControlViewDidResize(resizeControlView: ResizeControl)
    func resizeControlViewDidEndResizing(resizeControlView: ResizeControl)
}

class ResizeControl: UIView {
    // This view is associated with CropRectView. It can be topleft, topright, bottomleft, bottom right, center part of the CropRectView. Each one signals the CropRectView to move its position, size if pan gesture is recognized.
    
    var translation: CGPoint!
    var delegate: ResizeControlViewDelegate?
    
    var startPoint: CGPoint!
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: 44.0, height: 44.0))
        
        self.backgroundColor = UIColor.clear
        self.isExclusiveTouch = true
        
        let gestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handlePan(_ gr: UIPanGestureRecognizer) {
        
        switch gr.state {
        case .began:
            let translation = gr.translation(in: self.superview)
            self.startPoint = CGPoint(x: translation.x, y: translation.y)
            
            delegate?.resizeControlViewDidBeginResizing(resizeControlView: self)
        
        case .changed:
            let translation = gr.translation(in: self.superview)
            
            self.translation = CGPoint(x: self.startPoint.x + translation.x, y: self.startPoint.y + translation.y)
            
            delegate?.resizeControlViewDidResize(resizeControlView: self)
            
        case .ended, .cancelled:
            delegate?.resizeControlViewDidEndResizing(resizeControlView: self)
        
        default: break
        }
        
    }
}


