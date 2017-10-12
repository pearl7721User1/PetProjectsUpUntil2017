//
//  SubView1.swift
//  HitTestingTest
//
//  Created by SeoGiwon on 3/2/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class Level1View: UIView {
    
    var subview1 = Level2View()
//    var subview2 = Level2View()
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        subview1.backgroundColor = UIColor.red
//        subview2.backgroundColor = UIColor.green
        
        self.addSubview(subview1)
//        self.addSubview(subview2)
        
        subview1.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
//        subview2.frame = CGRect(x: 0, y: 100, width: 200, height: 100)
        
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        print("pointFromLevel1:\(point.x) \(point.y)")
        
        let subviews = self.subviews
        
        for subview in subviews {
            
            
            if let view = subview.hitTest(subview.convert(point, from: self), with: event) {
                print("subview:Level1")
                return view
            }
            
        }
        
        if (self.frame.contains(point)) {
            print("self:Level1")
            return self
        }
        else {
            return nil
        }
    }
}
