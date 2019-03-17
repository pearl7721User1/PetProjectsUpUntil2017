//
//  DownloadOngoingView.swift
//  CoreGraphicsDrawingSample
//
//  Created by SeoGiwon on 4/23/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit


class ProgressDrawingView: FlickerView {
    
    enum Status {
        case ready, progressing, waiting
    }
    
    var status = Status.ready {
        didSet {
            
            let newStatus = status
            
            switch newStatus {
            case .waiting:
                
                if loadingView.superview == nil {
                    self.addSubview(loadingView)
                }
                
            default:
                loadingView.removeFromSuperview()
                self.setNeedsDisplay()
            }
            
            
        }
    }
    
    private lazy var loadingView:UIView = {
        
        // get path
        let arcRect = self.bounds
        
        let arcRadius = (arcRect.size.height/2)
        let arcCenter = CGPoint(x: arcRect.origin.x + arcRect.size.width/2, y: arcRect.origin.y + arcRadius);
        
        let startAngle: CGFloat = -CGFloat(Double.pi / 4)
        let endAngle: CGFloat = CGFloat(Double.pi * 1.5)
        
        let path = CGMutablePath()
        path.addArc(center: arcCenter, radius: arcRadius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        
        // get layer
        let segment = CAShapeLayer()
        segment.frame = self.bounds
        segment.strokeColor = self.tintColor.cgColor
        segment.fillColor = UIColor.white.cgColor
        
        segment.lineWidth = 1.0;
        segment.path = path
        
        // add animation
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        let angle: CGFloat = CGFloat(Double.pi * 2)
        rotation.fromValue = 0
        rotation.toValue = angle
        rotation.duration = 1
        rotation.repeatCount = Float.greatestFiniteMagnitude
        rotation.isRemovedOnCompletion = false
        segment.add(rotation, forKey: nil)
        
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.white
        view.layer.addSublayer(segment)
        
        return view
    }()
    
    var progress: CGFloat = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    convenience init() {
        
        let rect = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.init(frame:rect)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let innerRect = rect.insetBy(dx: 1, dy: 1)
        let innerRect2 = rect.insetBy(dx: 3, dy: 3)
        
        if let context = UIGraphicsGetCurrentContext() {
            
            // set background to clear color
            context.setFillColor(UIColor.clear.cgColor)
            context.fill(rect)
            
            // draw rect circle
            context.setStrokeColor(self.tintColor.cgColor)
            context.strokeEllipse(in: innerRect)
            
            // draw progress
            draw(innerRect2, progress: self.progress, context: context)
            
            
            if (status == .progressing) {
                // draw rectangle
                context.setFillColor(self.tintColor.cgColor)
                context.fill(rect.insetBy(dx: 13, dy: 13))
            }
            else {
                // draw arrow
                context.setLineCap(.round)
                context.move(to: CGPoint(x: 20, y: 10))
                context.addLine(to: CGPoint(x: 20, y: 30))
                context.move(to: CGPoint(x: 20 - 7, y: 27))
                context.addLine(to: CGPoint(x: 20, y: 33))
                context.addLine(to: CGPoint(x: 20 + 7, y: 27))
                context.setLineWidth(1.0)
                context.strokePath()
            }
            
        }
    }
    
    private func draw(_ rect: CGRect, progress pr: CGFloat, context ctx: CGContext) {
        
        ctx.setStrokeColor(self.tintColor.cgColor)
        ctx.setLineWidth(4.0)
        
        let startAngle = CGFloat(CGFloat.pi/2)*3
        let endAngle = startAngle + CGFloat(CGFloat.pi/2)*4 * pr
        
        ctx.addArc(center: CGPoint(x:rect.midX, y:rect.midY), radius: rect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        ctx.strokePath()
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
    }
}
