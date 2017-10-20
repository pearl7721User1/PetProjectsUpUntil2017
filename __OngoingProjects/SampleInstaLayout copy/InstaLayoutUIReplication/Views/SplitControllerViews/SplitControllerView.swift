//
//  SplitControllerView.swift
//  ReplaceScrollViewTest
//
//  Created by SeoGiwon on 13/10/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class SplitControllerView: UIView {

    let defaultViewHeight = (UIScreen.main.bounds.size.height - 64) * (2.0 / 3.0)
    lazy var splitViewSize: CGSize = {
        
        return CGSize(width: UIScreen.main.bounds.size.width, height: self.defaultViewHeight)
    }()
    
    var snapShot: UIView?
    
    func createSnapShot() {
        
        snapShot = snapshotView(afterScreenUpdates: true)
    }
}
