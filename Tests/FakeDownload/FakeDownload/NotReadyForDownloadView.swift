//
//  AskingForDownloadView.swift
//  CoreGraphicsDrawingSample
//
//  Created by SeoGiwon on 4/23/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class NotReadyForDownloadView: UIView {

    let mainColor = UIColor.black
    let subColor = UIColor.red
    
    convenience init() {

        let rect = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.init(frame:rect)

        
        self.backgroundColor = UIColor.clear

        let shapeLayer = CAShapeLayer()
        let bezierPath = UIBezierPath()
        bezierPath.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width/2, startAngle: CGFloat(Double.pi / 2)*3, endAngle: CGFloat(Double.pi / 2)*6.3, clockwise: true)
        bezierPath.stroke()
        
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.strokeColor = mainColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.frame = self.bounds
        
        self.layer.addSublayer(shapeLayer)

        
        let move = CABasicAnimation(keyPath: "transform.rotation.z")//(keyPath: "position.y")
        move.toValue = Double.pi/2 * Double(4) //bar.position.y - 35.0
        move.duration = 1.0
        move.autoreverses = false
        move.repeatCount = Float.infinity
        
        
        shapeLayer.add(move, forKey: nil)

        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func image() -> UIImage {
        
        let size = CGSize(width:40, height:40)
        let rect = CGRect(origin: CGPoint.zero, size: size)
        let boundCircleRect = rect.insetBy(dx: 1, dy: 1)
        
        var newImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(size, false, 2.0)
        
        let bezierPath = UIBezierPath()
        bezierPath.addArc(withCenter: CGPoint(x: boundCircleRect.midX, y: boundCircleRect.midY), radius: boundCircleRect.width/2, startAngle: CGFloat(CGFloat.pi/2)*3, endAngle: CGFloat(CGFloat.pi/2)*6.3, clockwise: true)
        bezierPath.stroke()
        newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let innerRect = rect.insetBy(dx: 1, dy: 1)
        
        if let context = UIGraphicsGetCurrentContext() {
            
            // set background to clear color
            context.setFillColor(UIColor.clear.cgColor)
            context.fill(rect)
            
            let startAngle = CGFloat(M_PI_2)*3
            let endAngle = startAngle + CGFloat(M_PI_2)*3
            
            context.addArc(center: CGPoint(x:innerRect.midX, y:innerRect.midY), radius: innerRect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            context.strokePath()
            
        }
        
    }
    */

}
