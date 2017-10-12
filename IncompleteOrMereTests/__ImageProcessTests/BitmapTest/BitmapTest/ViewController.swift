//
//  ViewController.swift
//  BitmapTest
//
//  Created by SeoGiwon on 05/06/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 1. Get the raw pixels of the image
        var inputPixels = [UInt32]()
        
        let bytesPointer = UnsafeMutableRawPointer.allocate(bytes: 5*5*MemoryLayout.size(ofValue: UInt32()), alignedTo: 1)
//        bytesPointer.storeBytes(of: 0xFFFF_FFFF, as: UInt32.self)

//kCGImageAlphaPremultipliedFirst
        
        var context = CGContext(data: nil, width: 100, height: 100, bitsPerComponent: 8, bytesPerRow: 4*100, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)

        context?.addRect(CGRect(x: 1, y: 1, width: 50, height: 50))
        context?.strokePath()
        
        // 4. Create a new UIImage
        let CGImageRef = context?.makeImage()
        let processedImage = UIImage.init(cgImage: CGImageRef!)
        
        let imgView = UIImageView(image: processedImage)
        self.view.addSubview(imgView)
        imgView.center = self.view.center
        imgView.layer.borderColor = UIColor.black.cgColor
        imgView.layer.borderWidth = 1.0

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

