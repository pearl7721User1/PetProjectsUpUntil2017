//
//  FadingAnimator.swift
//  ImageEditorViewControllerTesting
//
//  Created by SeoGiwon on 1/28/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

protocol SpringUpAnimatorDelegate {
    
    // the copycat image view to actually perform view frame movement animation
    var springUpSnapShotImgView: UIImageView { get }
    
    // preliminary procedures before performing animation
    var springUpPreAnimationClosure: () -> () { get }
    
    // post procedures after performing animation
    var springUpPostAnimationClosure: () -> () { get }
    
    // the frame that the animation is going to
    var springUpToFrame: CGRect { get }
    
}

// This object implements custom view controller transition animation. It is intended for spring-up effect.
class SpringUpAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presentingDelegate: SpringUpAnimatorDelegate!
    
    init(delegate: SpringUpAnimatorDelegate) {
        super.init()
        presentingDelegate = delegate
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            
            fatalError("UITransitionContextViewKey.to for springUpAnimator is unavailable")
        }
        
        let containerView = transitionContext.containerView
        
        toView.frame = containerView.frame
        toView.alpha = 0.0 // toView starts from alpha 0.0, and increases its opacity for fromView's dissolving effect
        containerView.addSubview(toView)
        
        // get a copycat image view for animation
        let snapShotView = presentingDelegate.springUpSnapShotImgView
        let oldSnapShotViewFrame = snapShotView.frame
        containerView.addSubview(snapShotView)
        
        // do preliminary procedures for animation
        presentingDelegate.springUpPreAnimationClosure()

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: -0.4, options: [], animations: {
            
            toView.alpha = 1.0
            snapShotView.frame = self.presentingDelegate.springUpToFrame
            
        }, completion: { (finished) in
            
            snapShotView.removeFromSuperview()
            snapShotView.frame = oldSnapShotViewFrame
            transitionContext.completeTransition(finished)
            
            // do post procedures for animation
            self.presentingDelegate.springUpPostAnimationClosure()
        })
        
    }
    
}
