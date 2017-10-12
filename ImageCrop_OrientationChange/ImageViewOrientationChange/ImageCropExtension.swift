//
//  ImageCropExtension.swift
//  ImageViewOrientationChange
//
//  Created by SeoGiwon on 3/3/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

extension UIImage {
    
    func hasAlpha() -> Bool {
        // this func examines if this object has alpha Info
        
        let alphaInfo = self.cgImage!.alphaInfo
        return (alphaInfo != .none)
    }
    
    func croppedImageWith(Frame frame: CGRect) -> UIImage? {
        // This func returns a cropped image from the original one. The parameters refers to the size of the crop against the original image size        
        
        var croppedImage: UIImage?
        
        UIGraphicsBeginImageContextWithOptions(frame.size, hasAlpha(), 0.0)
        
        let context = UIGraphicsGetCurrentContext()
        
        if let ctx = context {
            ctx.translateBy(x: -frame.origin.x, y: -frame.origin.y)
            self.draw(at: CGPoint(x: 0, y: 0))
            croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        
        return croppedImage
    }
}
