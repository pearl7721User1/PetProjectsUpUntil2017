//
//  SubView2.swift
//  HitTestingTest
//
//  Created by SeoGiwon on 3/2/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class Level2View: UIView {

//    var subview1 = Level3View()
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
//        subview1.backgroundColor = UIColor.green
//        self.addSubview(subview1)
//        subview1.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
    }

    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        print("pointFromLevel2:\(point.x) \(point.y)")
        
        let subviews = self.subviews
        
        for subview in subviews {
            
            if let view = subview.hitTest(point, with: event) {
                print("subview:Level2")
                return view
            }
            
        }
        
        if (self.bounds.contains(point)) {
            print("self:Level2")
            return self
        }
        else {
            return nil
        }
    }

}
