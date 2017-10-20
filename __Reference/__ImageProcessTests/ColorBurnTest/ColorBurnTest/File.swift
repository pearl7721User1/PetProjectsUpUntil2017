//
//  File.swift
//  ColorBurnTest
//
//  Created by SeoGiwon on 14/07/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

extension UIImage {
    
    func colorizedByGiwon(with color:UIColor?) -> UIImage {
        guard let color = color else {
            return self
        }
        
        if size == CGSize.zero {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return self
        }
        color.setFill()
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        context.setBlendMode(.exclusion)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height);
        context.draw(self.cgImage!, in: rect)
        
        context.setBlendMode(.sourceAtop)
        context.addRect(rect)
        context.drawPath(using: .fill)
        
        guard let tinted = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return self
        }
        return tinted
    }
    
    
    /// Colorizes the image in the given color
    func colorized(with color:UIColor?) -> UIImage {
        guard let color = color else {
            return self
        }
        
        if size == CGSize.zero {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return self
        }
        color.setFill()
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        context.setBlendMode(.exclusion)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height);
        context.draw(self.cgImage!, in: rect)
        
        context.setBlendMode(.sourceIn)
        context.addRect(rect)
        context.drawPath(using: .fill)
        
        guard let tinted = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return self
        }
        return tinted
    }
    
    
    /// Returns a round cutout of the image
    var rounded: UIImage {
        let smallerEdgeLength = min(self.size.width, self.size.height)
        let squareSize = CGSize(width: smallerEdgeLength, height: smallerEdgeLength)
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: squareSize)
        UIGraphicsBeginImageContextWithOptions(squareSize, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: squareSize.height
            ).addClip()
        
        let drawY: CGFloat = (squareSize.height - self.size.height) / 2.0
        let drawx: CGFloat = (squareSize.width - self.size.width) / 2.0
        self.draw(at: CGPoint(x: drawx, y: drawY))
        return (UIGraphicsGetImageFromCurrentImageContext() ?? self)
    }
}
