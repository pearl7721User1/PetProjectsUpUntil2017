//
//  File.swift
//  PhotokitMomentsTesting
//
//  Created by SeoGiwon on 2/6/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit
import AVFoundation

extension MomentsViewController: SpringUpAnimatorDelegate {
    
    var springUpSnapShotImgView: UIImageView {
        
        get {
            guard let imgView = self.snapshotView else { fatalError("The copycat view for view controller transition animation doesn't exist.") }
            return imgView
        }
        
    }
    
    var springUpToFrame: CGRect {
        get {
            
            guard let snapshotImg = self.snapshotView?.image else { fatalError("The copycat view for view controller transition animation doesn't exist.") }
            return AVMakeRect(aspectRatio: snapshotImg.size, insideRect: self.view.frame)
        }
    }
    
    var springUpPreAnimationClosure: () -> () {
        
        return self.springUpPreVCTransitionClosure
    }
    var springUpPostAnimationClosure: () -> () {
        
        return self.springUpPostVCTransitionClosure
    }
}

extension MomentsViewController: ShrinkOffAnimatorDelegate {
    
    var shrinkSnapShotImgView: UIImageView {
        
        get {
            guard let snapshot = self.detailViewController?.snapShotImgView else { fatalError("The copycat view for view controller transition animation doesn't exist.") }
            return snapshot
        }
    }
    
    var shrinkToFrame: CGRect {
        get {
            guard let snapshot = self.snapshotView else { fatalError("The copycat view for view controller transition animation doesn't exist.") }
            return snapshot.frame
        }
    }
    
    var shrinkPreAnimationClosure: () -> () {
        
        return self.shrinkPreVCTransitionClosure
    }
    var shrinkPostAnimationClosure: () -> () {
        
        return self.shrinkPostVCTransitionClosure
    }
}
