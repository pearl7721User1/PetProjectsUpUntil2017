//
//  SplitControllerView.swift
//  ReplaceScrollViewTest
//
//  Created by SeoGiwon on 13/10/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class LayoutEditingView: UIView {

    /*
        SplitControllerView size is going to be proportional to the device size that it runs.
    */
    
    /// It defines how much the SplitControllerView frame's height takes by default
    let defaultViewHeight = (UIScreen.main.bounds.size.height - 64) * (2.0 / 3.0)
    
    /// It defines how much the SplitControllerView frame's size takes by default
    lazy var splitViewSize: CGSize = {
        return CGSize(width: UIScreen.main.bounds.size.width, height: self.defaultViewHeight)
    }()
    
    var snapShot: UIView?
    
    func createSnapShot() {
        
        snapShot = snapshotView(afterScreenUpdates: true)
    }
    
    /**
        A SplitControllerView is made of at least more than a couple of SplitUpScrollViews, each of which
        has image views with different sizes and positions depending on the SplitControllerView type.
        Override this function to set the default frames of the image views.
    */
    func setDefaultImageViewFrameOnSplitUpScrollView() {
        
    }
    
    
    
    
    var isDragging = false
    var selectedReplacee: ReplaceableScrollView? {
        didSet {
            if selectedReplacee != oldValue {
                oldValue?.removeLightBg()
            } else {
                selectedReplacee?.lighterBg()
            }
        }
    }
    
}
/*
extension PortableViewCollection: ReplaceableScrollViewDelegate {
    func viewDidDragged(portableView: ReplaceableScrollView) {
        isDragging = true
    }
    
    func viewDidMove(portableView: ReplaceableScrollView, to point: CGPoint) {
        
        
        if let candidate = self.replaceeCandidate(location: point) {
            selectedReplacee = candidate
            
        }
    }
    
    func viewDidDropped(portableView: ReplaceableScrollView) {
        
        isDragging = false
        
        guard let replacee = selectedReplacee else {
            fatalError("can't happen")
        }
        
        selectedReplacee = nil
        
        guard replacee != portableView else {
            portableView.dismissSnapshot()
            return
        }
        
        replace(view: portableView, viewSnapShot: portableView.snapShotView, theOther: replacee)
        
        
    }
}
*/
