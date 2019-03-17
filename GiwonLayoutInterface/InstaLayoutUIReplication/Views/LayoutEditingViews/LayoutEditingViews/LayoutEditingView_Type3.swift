//
//  SplitControllerView_Type3.swift
//  ReplaceScrollViewTest
//
//  Created by SeoGiwon on 12/10/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

/**
 LayoutEditingView_Type3 is a view that has four views(splitViewAlpha, splitViewBeta, splitViewGamma,
 splitViewDelta, and three size controls(sizeControlAlpha, sizeControlBeta, sizeControlGamma).
 |    |     |
 |    |     |
 |----|-----|
 |    |     |
 |    |     |
 
 */
class LayoutEditingView_Type3: LayoutEditingView {

    override func setDefaultImageViewFrameOnSplitUpScrollView() {
        let splitViewAlphaFrame = CGRect(x: 0, y: 0, width: splitViewSize.width / 2.0, height: defaultViewHeight / 2.0)
        
        let splitViewBetaFrame = CGRect(x: splitViewSize.width / 2.0, y: 0, width: splitViewSize.width / 2.0, height: defaultViewHeight / 2.0)
        
        let splitViewGammaFrame = CGRect(x: 0, y: defaultViewHeight / 2.0, width: splitViewSize.width / 2.0, height: defaultViewHeight / 2.0)
        
        let splitViewDeltaFrame = CGRect(x: splitViewSize.width / 2.0, y: defaultViewHeight / 2.0,
                                         width: splitViewSize.width / 2.0, height: defaultViewHeight / 2.0)
        
        
        splitViewAlpha.imageFrameSize  = splitViewAlphaFrame.size
        splitViewBeta.imageFrameSize = splitViewBetaFrame.size
        splitViewGamma.imageFrameSize = splitViewGammaFrame.size
        splitViewDelta.imageFrameSize = splitViewDeltaFrame.size
    }
    
    
    lazy var splitViewAlpha: SplitUpScrollView = { return SplitUpScrollView() }()
    lazy var splitViewBeta: SplitUpScrollView = { return SplitUpScrollView() }()
    lazy var splitViewGamma: SplitUpScrollView = { return SplitUpScrollView() }()
    lazy var splitViewDelta: SplitUpScrollView = { return SplitUpScrollView() }()
    
    lazy var sizeControlAlpha: LayoutEditingSizeControl = {
        
        let control = LayoutEditingSizeControl(controlType: .horizontal)
        control.delegate = self
        return control
    }()
    
    lazy var sizeControlBeta: LayoutEditingSizeControl = {
        
        let control = LayoutEditingSizeControl(controlType: .vertical)
        control.delegate = self
        return control
    }()
    
    lazy var sizeControlGamma: LayoutEditingSizeControl = {
        
        let control = LayoutEditingSizeControl(controlType: .both)
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
    
    private func commonInit() {
        self.addSubview(splitViewAlpha)
        self.addSubview(splitViewBeta)
        self.addSubview(splitViewGamma)
        self.addSubview(splitViewDelta)
        self.addSubview(sizeControlAlpha)
        self.addSubview(sizeControlBeta)
        self.addSubview(sizeControlGamma)
        
        setupConstraints()
        setDefaultImageViewFrameOnSplitUpScrollView()
        
        splitViewAlpha.image = UIImage(named: "IMG_2190.jpg")
        splitViewBeta.image = UIImage(named: "IMG_2189.jpg")
        splitViewGamma.image = UIImage(named: "IMG_2188.jpg")
        splitViewDelta.image = UIImage(named: "IMG_2873.jpg")
    }
    
    // setup constraints for all the subviews
    private func setupConstraints() {
        
        splitViewAlpha.setupConstraints(superview: self, size:
            CGSize(width: splitViewSize.width / 2.0,
                   height: defaultViewHeight / 2.0),
                                                 offset: CGPoint.zero)
        
        splitViewBeta.setupConstraints(superview: self, size:
            CGSize(width: splitViewSize.width / 2.0,
                   height: defaultViewHeight / 2.0),
                                                offset:
            CGPoint(x: splitViewSize.width / 2.0, y: 0))
        
        splitViewGamma.setupConstraints(superview: self, size:
            CGSize(width: splitViewSize.width / 2.0,
                   height: defaultViewHeight / 2.0),
                                                 offset:
            CGPoint(x: 0, y: defaultViewHeight / 2.0))
        
        splitViewDelta.setupConstraints(superview: self, size:
            CGSize(width: splitViewSize.width / 2.0,
                   height: defaultViewHeight / 2.0),
                                                 offset:
            CGPoint(x: splitViewSize.width / 2.0, y: defaultViewHeight / 2.0))
        
        
        sizeControlAlpha.setupConstraints(superview: self, size:
            CGSize(width: splitViewSize.width, height: 30),
                                                   centerOff: CGPoint.zero)
        
        sizeControlBeta.setupConstraints(superview: self, size:
            CGSize(width: 30, height: splitViewSize.height),
                                                   centerOff: CGPoint.zero)
        
        sizeControlGamma.setupConstraints(superview: self, size:
            CGSize(width: 30, height: 30),
                                                   centerOff: CGPoint.zero)
    }
}

extension LayoutEditingView_Type3: LayoutEditingSizeControlProtocol {
    func shouldMove(sizeControl: LayoutEditingSizeControl, delta: CGPoint, currentCenterOffset: CGPoint) -> Bool {
        
        /*
         The size control must stay in the boundRect. Otherwise, the
         movement must not be allowed.
         */
        
        let newCenterWillBe = CGPoint(x: delta.x + currentCenterOffset.x + self.bounds.midX,
                                      y: delta.y + currentCenterOffset.y + self.bounds.midY)
        
        var boundRect = CGRect.zero
        
        if sizeControl === self.sizeControlAlpha {
            boundRect = CGRect(x: 0, y: 50,
                              width: splitViewSize.width,
                              height: splitViewSize.height - 100)
            
        } else if sizeControl === self.sizeControlBeta {
            boundRect = CGRect(x: 50, y: 0,
                              width: splitViewSize.width - 100,
                              height: splitViewSize.height)

        } else if sizeControl === self.sizeControlGamma {
            boundRect = CGRect(x: 50, y: 50,
                              width: splitViewSize.width - 100,
                              height: splitViewSize.height - 100)
        } else {
            return false
        }
    
        return boundRect.contains(newCenterWillBe)
    }
    
    func didMove(sizeControl: LayoutEditingSizeControl, delta: CGPoint) {
        
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
