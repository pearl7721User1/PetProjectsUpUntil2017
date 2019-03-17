//
//  CropView.swift
//  ImageViewOrientationChange
//
//  Created by SeoGiwon on 1/30/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit
import AVFoundation

protocol CropViewDelegate {
    
    func cropDidOccur(to toImg: UIImage?, from fromImg: UIImage?, at cropOrigin: CGPoint?)
}

class CropView: UIView {

    // for interaction with its superview
    var delegate: CropViewDelegate?
    
    // sample image to crop
    var img = UIImage(named: "sample.jpg")
    
    // the subviews for this view
    var imageView: UIImageView!
    var cropRectView: CropRectView!
    
    // the image view's frame
    var imageViewFrame: CGRect? {
        didSet {
            imageView.frame = imageViewFrame!
        }
    }
    
    // Device orientation change causes this view and image view's frame changes, needing cropRectView frame's adjustment. preRotationCropRectRef stores cropRectView frame's percentage against image view. This information is useful in adjusting cropRectView.
    var preRotationCropRectRef: CGRect!
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: View Hierarchy, Layout
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        setup()
    }
    
    func setup() {
        // setup for subview's hierarchy
        imageView = UIImageView(image: img)
        self.addSubview(imageView)
        
        cropRectView = CropRectView()
        cropRectView.delegate = self
        preRotationCropRectRef = initPreRotationCropRectRef()
        self.addSubview(cropRectView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // This view and its subviews do not use AutoLayout, for I want the layout to be set dynamically. It's more preferrable approach for this case.
        
        setImageViewFrame()
        setCropRectFrame()
        preRotationCropRectRef = calculatePreRotationCropRectRef()
        
    }
    
    // MARK: Helper method
    func setCropRectFrame() {
        // Take preRotationCropRectRef as a reference, cropRectView's frame is newly determined. Device orientation change needs to call this func.
        
        let newOrigin = CGPoint(x: imageViewFrame!.size.width * preRotationCropRectRef.origin.x / 100.0,
                                y: imageViewFrame!.size.height * preRotationCropRectRef.origin.y / 100.0)
        let newSize = CGSize(width: imageViewFrame!.size.width * preRotationCropRectRef.size.width / 100.0,
                             height: imageViewFrame!.size.height * preRotationCropRectRef.size.height / 100.0)
        
        
        cropRectView.frame = self.convert(CGRect(origin: newOrigin, size: newSize), from: imageView)
        
    }
    
    
    func setImageViewFrame() {
        // The image view frame must be configured dynamically according to the image's size ratio.
        
        guard let img = self.img, self.bounds.width != 0.0 else {
            fatalError("Image view frame can't be determined.")
        }
        
        self.imageViewFrame = AVMakeRect(aspectRatio: img.size, insideRect: self.bounds)
    }
    
    func initPreRotationCropRectRef() -> CGRect {
        // This func determines cropRectView's initial position and size. Each value of the rect represents not the actual value but the percentage value against imageView.
        
        return CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
    }
    
    
    func calculatePreRotationCropRectRef() -> CGRect {
        // This func takes cropRectView's frame as a parameter; calculates its position, size in percentage against imageView. The returned rect is useful in adjusting cropRectView's frame when device orientation change occurs.
        
        let cropRectViewFrame = self.convert(cropRectView.frame, to: imageView)
        
        let xPct = 100.0 * cropRectViewFrame.origin.x / imageView.frame.size.width
        let yPct = 100.0 * cropRectViewFrame.origin.y / imageView.frame.size.height
        let widthPct = 100.0 * cropRectViewFrame.size.width / imageView.frame.size.width
        let heightPct = 100.0 * cropRectViewFrame.size.height / imageView.frame.size.height
        
        return CGRect(x: xPct, y: yPct, width: widthPct, height: heightPct)
    }
    
    // MARK: Hit Testing
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let subviews = self.subviews
        for subview in subviews {
            
            if let view = subview.hitTest(subview.convert(point, from: self), with: event) {
                return view
            }
        }
        
        if (self.frame.contains(point)) {
            return self
        }
        else {
            return nil
        }
    }
    
    // MARK: Crop
    func crop() {
        // This func takes CropRectView's frame as a crop parameter; crops the image; delivers it to its delegate which is its superview
        
        var croppedImg: UIImage?
        var cropOrigin: CGPoint?
        
        if let theImg = img {
            
            let imgScreenViewBounds = imageView.bounds
            let croppedScreenRect = imageView.convert(cropRectView.frame, from: self)
            
            // calculate size ratio between the image and the image view in the screen
            let imgOriginalSizeFactor =
                CGSize(width: theImg.size.width / imgScreenViewBounds.size.width,
                        height: theImg.size.height / imgScreenViewBounds.size.height)
            
            // determine crop rect
            let croppedImgRect = CGRect(
                x: (croppedScreenRect.origin.x * imgOriginalSizeFactor.width).rounded(.toNearestOrAwayFromZero),
                y: (croppedScreenRect.origin.y * imgOriginalSizeFactor.height).rounded(.toNearestOrAwayFromZero),
                width: (croppedScreenRect.size.width * imgOriginalSizeFactor.width).rounded(.toNearestOrAwayFromZero),
                height: (croppedScreenRect.size.height * imgOriginalSizeFactor.height).rounded(.toNearestOrAwayFromZero))
            
            cropOrigin = croppedImgRect.origin
            
            // crop the image
            croppedImg = theImg.croppedImageWith(Frame: croppedImgRect)
        }
        
        // deliver the cropped image to the superview
        delegate?.cropDidOccur(to: croppedImg, from: img, at: cropOrigin)
    }
    
}

extension CropView: CropRectViewDelegate {
    // these funcs define what to do in the event of cropRectView's frame changes
    
    func cropRectViewDidBeginEditing(cropRectView: CropRectView) {

    }
    
    func cropRectViewEditingChanged(cropRectView: CropRectView) {
        preRotationCropRectRef = calculatePreRotationCropRectRef()
    }
    
    func cropRectViewDidEndEditing(cropRectView: CropRectView) {

    }
    
    func cropRectViewBoundaryFrame() -> CGRect {
        return imageView.frame
    }
}
