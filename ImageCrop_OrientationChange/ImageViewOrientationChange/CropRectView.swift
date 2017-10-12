//
//  CropRectView.swift
//  CropViewSwiftTesting
//
//  Created by SeoGiwon on 1/22/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

protocol CropRectViewDelegate {
    
    func cropRectViewDidBeginEditing(cropRectView: CropRectView)
    func cropRectViewEditingChanged(cropRectView: CropRectView)
    func cropRectViewDidEndEditing(cropRectView: CropRectView)
    func cropRectViewBoundaryFrame() -> CGRect
}

class CropRectView: UIView {

    // for interaction with its superview
    var delegate: CropRectViewDelegate!
    
    // resizing controls
    var topLeftCornerView: ResizeControl!
    var topRightCornerView: ResizeControl!
    var bottomLeftCornerView: ResizeControl!
    var bottomRightCornerView: ResizeControl!
    var centerView: ResizeControl!

    // graphics to represent resize controls
    var imageView: UIImageView!
    
    // for dimming effects within CropRectView's bounds
    var dimmingView: UIView!
    
    // initialRect is a temporary variable. Funcs calling from the resize controls writes its temporary result to initialRect
    var initialRect: CGRect!
    
    // This view's superview, which is a CropView, has another view which is sibiling to this view. This view's frame must not lie beyond it.
    var frameBoundary: CGRect!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // configure for this view
        self.backgroundColor = UIColor.clear
        self.alpha = 1.0
        self.contentMode = .redraw
        
        // Set the subview's hierarchy. The frame for each subview is defined in layoutSubviews() func.
        dimmingView = UIView()
        dimmingView.backgroundColor = UIColor.black
        dimmingView.alpha = 0.3
        self.addSubview(dimmingView)
        
        imageView = UIImageView(frame: self.bounds.insetBy(dx: -7.5, dy: -7.5))
        let image = UIImage(named: "resizingControl.png")
        let resizableImg = image?.resizableImage(withCapInsets: UIEdgeInsetsMake(23, 23, 23, 23))
        imageView.image = resizableImg
        self.addSubview(imageView)
        
        self.centerView = ResizeControl()
//        self.centerView.backgroundColor = UIColor.magenta
        self.centerView.delegate = self
        self.addSubview(centerView)
        
        self.topLeftCornerView = ResizeControl()
//        self.topLeftCornerView.backgroundColor = UIColor.red
        self.topLeftCornerView.delegate = self
        self.addSubview(topLeftCornerView)
        
        self.topRightCornerView = ResizeControl()
        self.topRightCornerView.delegate = self
//        self.topRightCornerView.backgroundColor = UIColor.blue
        self.addSubview(topRightCornerView)
        
        self.bottomLeftCornerView = ResizeControl()
        self.bottomLeftCornerView.delegate = self
//        self.bottomLeftCornerView.backgroundColor = UIColor.green
        self.addSubview(bottomLeftCornerView)
        
        self.bottomRightCornerView = ResizeControl()
        self.bottomRightCornerView.delegate = self
//        self.bottomRightCornerView.backgroundColor = UIColor.yellow
        self.addSubview(bottomRightCornerView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        // Make sure each resize control assumes its position when this view's frame change occurs. So does imageView which is the graphics to represent resize controls
        
        super.layoutSubviews()
        
        self.topLeftCornerView.frame = CGRect(origin:
            CGPoint(x:self.topLeftCornerView.bounds.width / -2,
                    y:self.topLeftCornerView.bounds.height / -2), size: self.topLeftCornerView.bounds.size)
        
        self.topRightCornerView.frame = CGRect(origin:
            CGPoint(x:self.bounds.width - self.topRightCornerView.bounds.width / 2,
                    y:self.topRightCornerView.bounds.height / -2), size: self.topRightCornerView.bounds.size)
        
        self.bottomLeftCornerView.frame = CGRect(origin:
            CGPoint(x:self.bottomLeftCornerView.bounds.width / -2,
                    y:self.bounds.height - self.bottomLeftCornerView.bounds.height / 2), size: self.bottomLeftCornerView.bounds.size)
        
        self.bottomRightCornerView.frame = CGRect(origin:
            CGPoint(x:self.bounds.width - self.bottomRightCornerView.bounds.width / 2,
                    y:self.bounds.height - self.bottomRightCornerView.bounds.height / 2), size: self.bottomRightCornerView.bounds.size)
        self.imageView.frame = self.bounds.insetBy(dx: -7.5, dy: -7.5)
        
        self.centerView.frame = CGRect(origin: CGPoint(x:self.topLeftCornerView.frame.maxX, y:self.topLeftCornerView.frame.maxY), size: CGSize(width: self.topRightCornerView.frame.minX - self.topLeftCornerView.frame.maxX, height: self.bottomLeftCornerView.frame.minY - self.topLeftCornerView.frame.maxY))
        
        self.dimmingView.frame = self.bounds
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Whatever is delievered to this view's hit testing, make sure that each of this view's resize control has its chances.
        
        let subviews = self.subviews
        
        for subview in subviews {
            
            if subview .isKind(of: ResizeControl.self) {
                if subview.frame.contains(point) {
                    return subview
                }
            }
        }
        
        return nil
    }
    
    
    func newFrameForTheView(by resizeControlView: ResizeControl) -> CGRect {
        // This func takes one of this view's resize control as a parameter; examines its translation value; returns new frame. Make sure that the new frame does not lie beyond this view's sibiling(the image view for cropping)'s frame
        
        var rect = self.frame

        enum FrameReference {
            case min, max
        }
        
        guard self.superview != nil else { fatalError() }
        
        // This view's frame must not lie beyond the image view(CropRectView's sibling in the CropView's hierarchy).
        let frameBoundary = delegate.cropRectViewBoundaryFrame()
        
        let rectifyTranslationX = {(translationX: CGFloat, frameValue: CGFloat, reference: FrameReference) -> (CGFloat) in
            
            
            let maxX = frameBoundary.maxX
            let minX = frameBoundary.minX
            
            var newX: CGFloat
            
            if reference == .max {
                
                if (translationX + frameValue > maxX) {
                    newX = maxX - frameValue
                } else {
                    newX = translationX
                }
                
            }
            else {
                if (translationX + frameValue < minX) {
                    newX = minX - frameValue
                } else {
                    newX = translationX
                }
            }
            
            return newX
        }
        
        let rectifyTranslationY = {(translationY: CGFloat, frameValue: CGFloat, reference: FrameReference) -> (CGFloat) in
            
            let maxY = frameBoundary.maxY
            let minY = frameBoundary.minY
            
            var newY: CGFloat
            
            if reference == .max {
                
                if (translationY + frameValue > maxY) {
                    newY = maxY - frameValue
                } else {
                    newY = translationY
                }
            }
            else {
                if (translationY + frameValue < minY) {
                    newY = minY - frameValue
                } else {
                    newY = translationY
                }
            }
            
            return newY
        }
        
        if resizeControlView == self.topLeftCornerView {
            
            let newTranslatedX = rectifyTranslationX(resizeControlView.translation.x, self.initialRect.minX, FrameReference.min)
            let newTranslatedY = rectifyTranslationY(resizeControlView.translation.y, self.initialRect.minY, FrameReference.min)
            
            rect = CGRect(x: self.initialRect.minX + newTranslatedX,
                          y: self.initialRect.minY + newTranslatedY,
                          width: self.initialRect.width - newTranslatedX,
                          height: self.initialRect.height - newTranslatedY)
            
        }
        else if resizeControlView == self.topRightCornerView {
            
            let newTranslatedX = rectifyTranslationX(resizeControlView.translation.x, self.initialRect.maxX, FrameReference.max)
            let newTranslatedY = rectifyTranslationY(resizeControlView.translation.y, self.initialRect.minY, FrameReference.min)
            
            rect = CGRect(x: self.initialRect.minX,
                          y: self.initialRect.minY + newTranslatedY,
                          width: self.initialRect.width + newTranslatedX,
                          height: self.initialRect.height - newTranslatedY)
        }
        else if resizeControlView == self.bottomLeftCornerView {
            
            let newTranslatedX = rectifyTranslationX(resizeControlView.translation.x, self.initialRect.minX, FrameReference.min)
            let newTranslatedY = rectifyTranslationY(resizeControlView.translation.y, self.initialRect.maxY, FrameReference.max)
            
            rect = CGRect(x: self.initialRect.minX + newTranslatedX,
                          y: self.initialRect.minY,
                          width: self.initialRect.width - newTranslatedX,
                          height: self.initialRect.height + newTranslatedY)
        }
        else if resizeControlView == self.bottomRightCornerView {
            
            let newTranslatedX = rectifyTranslationX(resizeControlView.translation.x, self.initialRect.maxX, FrameReference.max)
            let newTranslatedY = rectifyTranslationY(resizeControlView.translation.y, self.initialRect.maxY, FrameReference.max)
            
            rect = CGRect(x: self.initialRect.minX,
                          y: self.initialRect.minY,
                          width: self.initialRect.width + newTranslatedX,
                          height: self.initialRect.height + newTranslatedY)
            
        }
        else if resizeControlView == self.centerView {
            
            rect = CGRect(x: self.initialRect.minX + resizeControlView.translation.x,
                          y: self.initialRect.minY + resizeControlView.translation.y,
                          width: self.initialRect.width,
                          height: self.initialRect.height)
            
            let maxX = frameBoundary.maxX
            let maxY = frameBoundary.maxY
            let minX = frameBoundary.minX
            let minY = frameBoundary.minY
            
            if rect.maxX > maxX {
                let deltaX = rect.maxX - maxX
                rect.origin = CGPoint(x: rect.origin.x - deltaX, y: rect.origin.y)
            }
            
            if rect.maxY > maxY {
                let deltaY = rect.maxY - maxY
                rect.origin = CGPoint(x: rect.origin.x, y: rect.origin.y - deltaY)
            }
            
            if rect.minX < minX {
                let deltaX = minX - rect.minX
                rect.origin = CGPoint(x: rect.origin.x + deltaX, y: rect.origin.y)
            }
            
            if rect.minY < minY {
                let deltaY = minY - rect.minY
                rect.origin = CGPoint(x: rect.origin.x, y: rect.origin.y + deltaY)
            }

        }
        
        let minWidth: CGFloat = self.topLeftCornerView.bounds.width + self.topRightCornerView.bounds.width
        if rect.width < minWidth {
            rect.origin.x = self.frame.maxX - minWidth
            rect.size.width = minWidth
        }
        
        let minHeight: CGFloat = self.topLeftCornerView.bounds.height + self.bottomLeftCornerView.bounds.height
        if rect.height < minHeight {
            rect.origin.y = self.frame.maxY - minHeight
            rect.size.height = minHeight
        }
      
        return rect
    }

}

extension CropRectView: ResizeControlViewDelegate {
    // These funcs are called if one of its ResizeControl signals for the need of change of this view(CropRectView)'s frame
    
    func resizeControlViewDidBeginResizing(resizeControlView: ResizeControl) {
        
        self.initialRect = self.frame;
        delegate?.cropRectViewDidBeginEditing(cropRectView: self)
    }
    
    func resizeControlViewDidResize(resizeControlView: ResizeControl) {
        
        self.frame = newFrameForTheView(by: resizeControlView)
        delegate?.cropRectViewEditingChanged(cropRectView: self)
    }
    
    func resizeControlViewDidEndResizing(resizeControlView: ResizeControl) {
        delegate?.cropRectViewDidEndEditing(cropRectView: self)
    }
    
}
