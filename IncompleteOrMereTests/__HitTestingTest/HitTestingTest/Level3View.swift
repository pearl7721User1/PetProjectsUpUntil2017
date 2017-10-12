//
//  Level3View.swift
//  HitTestingTest
//
//  Created by SeoGiwon on 3/2/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class Level3View: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        print("pointFromLevel3:\(point.x) \(point.y)")
        
        let subviews = self.subviews
        
        for subview in subviews {
            
            if let view = subview.hitTest(point, with: event) {
                print("subview:Level3")
                return view
            }
            
        }
        
        if (self.bounds.contains(point)) {
            print("self:Level3")
            return self
        }
        else {
            return nil
        }
    }
}
