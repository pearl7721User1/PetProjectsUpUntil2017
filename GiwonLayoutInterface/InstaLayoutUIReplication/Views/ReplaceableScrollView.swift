//
//  ReplaceableScrollView.swift
//  ReplaceScrollViewTest
//
//  Created by SeoGiwon on 11/08/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

protocol ReplaceableScrollViewDelegate {
    
    func viewDidDragged(portableView: ReplaceableScrollView)
    func viewDidMove(portableView: ReplaceableScrollView, to point: CGPoint)
    func viewDidDropped(portableView: ReplaceableScrollView)
}

class ReplaceableScrollView: SplitUpScrollView {

    lazy var lightBgLayer: CALayer = {
        let layer = CALayer()
        layer.frame = self.bounds
        layer.backgroundColor = UIColor.white.withAlphaComponent(0.3).cgColor
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.blue.cgColor
        
        return layer
    }()
        
    var snapShotView: UIView?
    var dragStartingPointDeltaInThisView: CGPoint?
    var replaceableScrollViewDelegate: ReplaceableScrollViewDelegate?
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        self.addGestureRecognizer(longGesture)

    }
    
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        
        guard let superview = superview else { return }

        
        
        switch sender.state {
        case .began:
            
            snapShotView = self.snapShot()
            snapShotView?.center = center
            snapShotView?.alpha = 0.95
            superview.addSubview(snapShotView!)
            self.alpha = 0.0
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.snapShotView?.center = self.center
                self.snapShotView?.transform = CGAffineTransform.init(scaleX: 1.05, y: 1.05)


            }, completion: { (finished) -> Void in
                self.isHidden = true
            })

            
            dragStartingPointDeltaInThisView = CGPoint(x: sender.location(in: superview).x - self.center.x, y: sender.location(in: superview).y - self.center.y)
            
            replaceableScrollViewDelegate?.viewDidDragged(portableView: self)
            
        case .changed:
            
            
            let newLocation = sender.location(in: superview)
            
            snapShotView?.center = CGPoint(x: newLocation.x - (dragStartingPointDeltaInThisView?.x ?? 0), y:newLocation.y - (dragStartingPointDeltaInThisView?.y ?? 0))
        
            
            replaceableScrollViewDelegate?.viewDidMove(portableView: self, to: newLocation)
            
        case .ended, .cancelled:
            
            replaceableScrollViewDelegate?.viewDidDropped(portableView: self)

        default:
            break
        }
    }
    
    func dismissSnapshot() {
        
        
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: { 
            self.snapShotView?.center = self.center
            self.snapShotView?.transform = CGAffineTransform.identity
            
        }, completion: { (finished) -> Void in
            self.dragDropCompleted()
        })
        
       
    }
    
    func dragDropCompleted() {
        self.alpha = 1.0
        self.isHidden = false
        self.snapShotView?.removeFromSuperview()
    }
    
    func lighterBg() {
        self.layer.addSublayer(lightBgLayer)
    }
    
    func removeLightBg() {
        lightBgLayer.removeFromSuperlayer()
    }
    

    
    func snapShot() -> UIView {
        // This func is called to get the window screen shot view. The screenshot is going to be the background of the DetailViewController's view only with the alpha value 0. If it is pulled, then it is revealed.
        
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        let view = UIView(frame: self.frame)
        view.layer.contents = screenshot?.cgImage
        
        self.snapShotView = view
        
        return view
    }

}
