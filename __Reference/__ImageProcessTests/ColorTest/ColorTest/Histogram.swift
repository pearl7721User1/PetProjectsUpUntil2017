//
//  Histogram.swift
//  ColorTest
//
//  Created by SeoGiwon on 13/06/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

/*
#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
#define A(x) ( Mask8(x >> 24) )
#define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )
*/

func Mask8(x: UInt32) -> UInt32 {
    return x & 0xFF
}

func R(x: UInt32) -> UInt32 {
    return Mask8(x: x)
}

func G(x: UInt32) -> UInt32 {
    return Mask8(x: x >> 8)
}

func B(x: UInt32) -> UInt32 {
    return Mask8(x: x >> 16)
}

func A(x: UInt32) -> UInt32 {
    return Mask8(x: x >> 24)
}


class Histogram {
    
    static func histogramElements(from img:UIImage) -> HistogramElements? {
        
        // read img pixels
        guard let pixels = Histogram.inputPixels(from: img) else {
            return nil
        }
        
        var rgbElements = HistogramElements.init()
        
        for pixelInfo in pixels {
            let r = UInt8(truncatingBitPattern: R(x: pixelInfo))
            let g = UInt8(truncatingBitPattern: G(x: pixelInfo))
            let b = UInt8(truncatingBitPattern: B(x: pixelInfo))
            
            rgbElements.R[Int(r)] += 1
            rgbElements.G[Int(g)] += 1
            rgbElements.B[Int(b)] += 1
        }
        
        return rgbElements
    }
    
    static func inputPixels(from img:UIImage) -> [UInt32]? {
        
        guard let inputCGImage = img.cgImage else {
            return nil
        }
        
        let inputWidth = inputCGImage.width
        let inputHeight = inputCGImage.height
        let bytesPerPixel: Int = 4
        let bitsPerComponent: Int = 8
        
        
        let inputPixels = UnsafeMutablePointer<UInt32>.allocate(capacity: inputWidth * inputHeight)
        
        let context = CGContext(data: inputPixels, width: inputWidth, height: inputHeight, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerPixel*inputWidth, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        context?.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: inputWidth, height: inputHeight))
        
        let array = Array(UnsafeBufferPointer(start: inputPixels, count: inputHeight * inputWidth))
        
        return array
    }
}
