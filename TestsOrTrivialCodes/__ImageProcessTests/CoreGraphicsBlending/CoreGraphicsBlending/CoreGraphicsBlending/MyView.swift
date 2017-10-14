//
//  MyView.swift
//  CoreGraphicsBlending
//
//  Created by SeoGiwon on 17/06/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class MyView: UIView {

    var blendMode = CGBlendMode.clear {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
//        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return
        }
        
        let rectangle = CGRect(x: 0, y: 0, width: 200, height: 200)
        context.addEllipse(in: rectangle)
        context.setFillColor(UIColor.red.cgColor)
        context.fillPath()

        context.setBlendMode(blendMode)
        
        let rectangle2 = CGRect(x: 50, y: 100, width: 150, height: 150)
        context.addEllipse(in: rectangle2)
        context.setFillColor(UIColor.red.cgColor)//(UIColor(red: 0.3, green: 0.5, blue: 0.7, alpha: 1.0).cgColor)
        context.fillPath()
    }
 

}
