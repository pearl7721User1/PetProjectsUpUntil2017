//
//  File.swift
//  PhotokitMomentsTesting
//
//  Created by SeoGiwon on 2/6/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

protocol ShrinkOffAnimatorDelegate {
    
    // the copycat image view to actually perform view frame movement animation
    var shrinkSnapShotImgView: UIImageView { get }
    
    // preliminary procedures before performing animation
    var shrinkPreAnimationClosure: () -> () { get }
    
    // post procedures after performing animation
    var shrinkPostAnimationClosure: () -> () { get }
    
    // the frame that the animation is going to
    var shrinkToFrame: CGRect { get }
    
}

// This object implements custom view controller transition animation. It is intended for shrink-off effect.
class ShrinkOffAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var dismissingDelegate: ShrinkOffAnimatorDelegate!
    
    init(delegate: ShrinkOffAnimatorDelegate) {
        super.init()
        dismissingDelegate = delegate
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to),
            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
                
            fatalError("UITransitionContextViewKey.to, from for shrinkOffAnimator is unavailable")
        }
        
        let containerView = transitionContext.containerView
        fromView.frame = containerView.frame
        fromView.alpha = 0.0
        toView.frame = containerView.frame
        containerView.insertSubview(toView, belowSubview: fromView)
        
        // get a copycat image view for animation
        let snapShotView = dismissingDelegate.shrinkSnapShotImgView        
        containerView.addSubview(snapShotView)
        
        // do preliminary procedures for animation
        dismissingDelegate.shrinkPreAnimationClosure()

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: -0.1, options: [], animations: {
            
            snapShotView.frame = self.dismissingDelegate.shrinkToFrame
            
        }, completion: { (finished) in
            
            snapShotView.removeFromSuperview()
            fromView.removeFromSuperview()
            
            // do post procedures for animation
            self.dismissingDelegate.shrinkPostAnimationClosure()

            transitionContext.completeTransition(finished)
        })
    }
    
}
