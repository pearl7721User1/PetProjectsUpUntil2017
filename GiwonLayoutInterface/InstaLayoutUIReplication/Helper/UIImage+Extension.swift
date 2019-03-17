//
//  UIImage+Extension.swift
//  InstaLayoutUIReplication
//
//  Created by SeoGiwon on 02/12/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// It returns the image size that fits to a given frame size in content aspect fill mode
    func scaleAspectFillSize(against frameSize: CGSize) -> CGSize {
        
        let frameWHRate = frameSize.width / frameSize.height
        let imgWHRate = self.size.width / self.size.height
        
        // decides the scale factor to be applied for both edges of the image
        let factor = frameWHRate > imgWHRate ?
            self.size.width / frameSize.width :
            self.size.height / frameSize.height
        
        // apply scale factor
        let newSize = CGSize(width: self.size.width / factor, height: self.size.height / factor)
        return newSize
    }
    
/*
    func getNewImage(forRect rect: CGRect) -> UIImage? {
        
        guard let cgImage = self.cgImage,
            let colorSpace = cgImage.colorSpace else { return nil }
        
        let newWidth =  floorf(Float(rect.width))
        
        let newBitmapContext = CGContext.init(data: nil, width: Int(newWidth), height: Int(rect.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: Int(CGFloat(cgImage.bytesPerRow) / CGFloat(cgImage.width) * CGFloat(newWidth)), space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        
        newBitmapContext?.draw(cgImage, in: rect)
        let imgRef = newBitmapContext?.makeImage()
        
        if let imgRef = imgRef {
            return UIImage(cgImage: imgRef)
        } else {
            return nil
        }
    }
*/
}
