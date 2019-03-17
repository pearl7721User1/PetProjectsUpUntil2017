//
//  RadioIndicatorView.swift
//  DownloadControllerTest
//
//  Created by SeoGiwon on 03/08/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

@IBDesignable
class CircleIndicatorView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.setLineWidth(1.0)
        context?.setFillColor(self.tintColor.cgColor)
        
        let radius: CGFloat = 8
        let origin = CGPoint(x:self.bounds.midX - radius, y:self.bounds.midY - radius)
        let size = CGSize(width: radius*2, height: radius*2)
        let rect = CGRect(origin: origin, size: size)
        
        
        context?.addEllipse(in: rect)
        context?.drawPath(using: .fillStroke)
    }
 

}
