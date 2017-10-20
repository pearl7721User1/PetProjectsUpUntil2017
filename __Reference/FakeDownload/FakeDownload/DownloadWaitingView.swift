//
//  DownloadWaitingView.swift
//  FakeDownload
//
//  Created by SeoGiwon on 17/09/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class DownloadWaitingView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    
    convenience init() {
        
        let rect = CGRect(x: 0, y: 0, width: 80, height: 80)
        self.init(frame:rect)
        
        // get path
        let arcRect = CGRect(x: 0, y: 0, width: 80, height: 80)
        
        let arcRadius = (arcRect.size.height/2)
        let arcCenter = CGPoint(x: arcRect.origin.x + arcRect.size.width/2, y: arcRect.origin.y + arcRadius);
        
        let startAngle: CGFloat = -CGFloat(Double.pi / 4)
        let endAngle: CGFloat = CGFloat(Double.pi * 1.5)
        
        let path = CGMutablePath()
        path.addArc(center: arcCenter, radius: arcRadius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        
        // get layer
        let segment = CAShapeLayer()
        segment.frame = self.bounds
        segment.strokeColor = UIColor.white.cgColor
        
        segment.lineWidth = 1.0;
        segment.path = path
        
        // add animation
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        let angle: CGFloat = CGFloat(Double.pi * 2)
        rotation.fromValue = 0
        rotation.toValue = angle
        rotation.duration = 1
        rotation.repeatCount = Float.greatestFiniteMagnitude
        segment.add(rotation, forKey: nil)
        

        self.layer.addSublayer(segment)
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
