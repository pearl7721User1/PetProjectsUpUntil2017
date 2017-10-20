//
//  SplitControllerView_Type3.swift
//  ReplaceScrollViewTest
//
//  Created by SeoGiwon on 12/10/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class SplitControllerView_Type3: SplitControllerView {

    func defaultSplitViewFramePixel() {
        let splitViewAlphaFrame = CGRect(x: 0, y: 0, width: splitViewSize.width / 2.0, height: defaultViewHeight / 2.0)
        
        let splitViewBetaFrame = CGRect(x: splitViewSize.width / 2.0, y: 0, width: splitViewSize.width / 2.0, height: defaultViewHeight / 2.0)
        
        let splitViewGammaFrame = CGRect(x: 0, y: defaultViewHeight / 2.0, width: splitViewSize.width / 2.0, height: defaultViewHeight / 2.0)
        
        let splitViewDeltaFrame = CGRect(x: splitViewSize.width / 2.0, y: defaultViewHeight / 2.0,
                                         width: splitViewSize.width / 2.0, height: defaultViewHeight / 2.0)
        
        
        splitViewAlpha.scrollViewFrame  = splitViewAlphaFrame
        splitViewBeta.scrollViewFrame = splitViewBetaFrame
        splitViewGamma.scrollViewFrame = splitViewGammaFrame
        splitViewDelta.scrollViewFrame = splitViewDeltaFrame
    }
    

    
    
    lazy var splitViewAlpha: SplitScrollView = { return SplitScrollView() }()
    lazy var splitViewBeta: SplitScrollView = { return SplitScrollView() }()
    lazy var splitViewGamma: SplitScrollView = { return SplitScrollView() }()
    lazy var splitViewDelta: SplitScrollView = { return SplitScrollView() }()
    
    lazy var sizeControlAlpha: SplitViewSizeControl = {
        
        let control = SplitViewSizeControl(controlType: .horizontal)
        control.delegate = self
        return control
    }()
    
    lazy var sizeControlBeta: SplitViewSizeControl = {
        
        let control = SplitViewSizeControl(controlType: .vertical)
        control.delegate = self
        return control
    }()
    
    lazy var sizeControlGamma: SplitViewSizeControl = {
        
        let control = SplitViewSizeControl(controlType: .both)
        control.delegate = self
        return control
    }()
    
    
    init() {
        super.init(frame: CGRect.zero)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.addSubview(splitViewAlpha)
        self.addSubview(splitViewBeta)
        self.addSubview(splitViewGamma)
        self.addSubview(splitViewDelta)
        self.addSubview(sizeControlAlpha)
        self.addSubview(sizeControlBeta)
        self.addSubview(sizeControlGamma)
        
        setupConstraints()
        defaultSplitViewFramePixel()
        
        splitViewAlpha.image = UIImage(named: "IMG_2190.jpg")
        splitViewBeta.image = UIImage(named: "IMG_2189.jpg")
        splitViewGamma.image = UIImage(named: "IMG_2188.jpg")
        splitViewDelta.image = UIImage(named: "IMG_2873.jpg")
    }
    

    func setupConstraints() {
        
        splitViewAlpha.setupSuperviewConstraints(superview: self, size:
            CGSize(width: splitViewSize.width / 2.0,
                   height: defaultViewHeight / 2.0),
                                                 offset: CGPoint.zero)
        
        splitViewBeta.setupSuperviewConstraints(superview: self, size:
            CGSize(width: splitViewSize.width / 2.0,
                   height: defaultViewHeight / 2.0),
                                                offset:
            CGPoint(x: splitViewSize.width / 2.0, y: 0))
        
        splitViewGamma.setupSuperviewConstraints(superview: self, size:
            CGSize(width: splitViewSize.width / 2.0,
                   height: defaultViewHeight / 2.0),
                                                 offset:
            CGPoint(x: 0, y: defaultViewHeight / 2.0))
        
        splitViewDelta.setupSuperviewConstraints(superview: self, size:
            CGSize(width: splitViewSize.width / 2.0,
                   height: defaultViewHeight / 2.0),
                                                 offset:
            CGPoint(x: splitViewSize.width / 2.0, y: defaultViewHeight / 2.0))
        
        
        sizeControlAlpha.setupSuperviewConstraints(superview: self, size:
            CGSize(width: splitViewSize.width, height: 30),
                                                   centerOff: CGPoint.zero)
        
        sizeControlBeta.setupSuperviewConstraints(superview: self, size:
            CGSize(width: 30, height: splitViewSize.height),
                                                   centerOff: CGPoint.zero)
        
        sizeControlGamma.setupSuperviewConstraints(superview: self, size:
            CGSize(width: 30, height: 30),
                                                   centerOff: CGPoint.zero)
    }
}

extension SplitControllerView_Type3: SplitViewSizeControlProtocol {
    func shouldMove(sizeControl: SplitViewSizeControl, newCenterOff: CGPoint) -> Bool {
        
        let newCenterPt = CGPoint(x: self.bounds.midX + newCenterOff.x,
                                  y: self.bounds.midY + newCenterOff.y)
        
        if sizeControl === self.sizeControlAlpha {
            
            let rect = CGRect(x: 0, y: 50,
                              width: splitViewSize.width,
                              height: splitViewSize.height - 100)
            
            return rect.contains(newCenterPt)
            
        }
        
        if sizeControl === self.sizeControlBeta {
            
            let rect = CGRect(x: 50, y: 0,
                              width: splitViewSize.width - 100,
                              height: splitViewSize.height)
            
            return rect.contains(newCenterPt)
            
        }
        
        if sizeControl === self.sizeControlGamma {
            
            let rect = CGRect(x: 50, y: 50,
                              width: splitViewSize.width - 100,
                              height: splitViewSize.height - 100)
            
            return rect.contains(newCenterPt)
        }
        
        return false
    }
    
    func didMove(sizeControl: SplitViewSizeControl, delta: CGPoint) {
        
        if sizeControl === self.sizeControlAlpha {
            
            self.splitViewAlpha.update(sizeDelta: CGSize(width: 0, height: delta.y))
            self.splitViewBeta.update(sizeDelta: CGSize(width: 0, height: delta.y))
            
            self.splitViewGamma.update(offsetDelta: CGPoint(x: 0, y: delta.y))
            self.splitViewGamma.update(sizeDelta: CGSize(width: 0, height: -delta.y))
            
            self.splitViewDelta.update(offsetDelta: CGPoint(x: 0, y: delta.y))
            self.splitViewDelta.update(sizeDelta: CGSize(width: 0, height: -delta.y))
            
            self.sizeControlGamma.update(offsetDelta: CGPoint(x: 0, y: delta.y))
        }
        
        if sizeControl === self.sizeControlBeta {
            
            self.splitViewAlpha.update(sizeDelta: CGSize(width: delta.x, height: 0))
            self.splitViewGamma.update(sizeDelta: CGSize(width: delta.x, height: 0))
            
            
            self.splitViewBeta.update(offsetDelta: CGPoint(x: delta.x, y: 0))
            self.splitViewBeta.update(sizeDelta: CGSize(width: -delta.x, height: 0))
            
            self.splitViewDelta.update(offsetDelta: CGPoint(x: delta.x, y: 0))
            self.splitViewDelta.update(sizeDelta: CGSize(width: -delta.x, height: 0))
            
            self.sizeControlGamma.update(offsetDelta: CGPoint(x: delta.x, y: 0))
        }
        
        if sizeControl === self.sizeControlGamma {
            
            self.splitViewAlpha.update(sizeDelta: CGSize(width: delta.x, height: delta.y))
            
            self.splitViewBeta.update(offsetDelta: CGPoint(x: delta.x, y: 0))
            self.splitViewBeta.update(sizeDelta: CGSize(width: -delta.x, height: delta.y))

            self.splitViewGamma.update(offsetDelta: CGPoint(x: 0, y: delta.y))
            self.splitViewGamma.update(sizeDelta: CGSize(width: delta.x, height: -delta.y))
            
            self.splitViewDelta.update(offsetDelta: CGPoint(x: delta.x, y: delta.y))
            self.splitViewDelta.update(sizeDelta: CGSize(width: -delta.x, height: -delta.y))
            
            self.sizeControlAlpha.update(offsetDelta: CGPoint(x: 0, y: delta.y))
            self.sizeControlBeta.update(offsetDelta: CGPoint(x: delta.x, y: 0))
        }
    }
}
