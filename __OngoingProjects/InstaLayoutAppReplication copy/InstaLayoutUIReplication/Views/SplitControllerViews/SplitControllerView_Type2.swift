//
//  SplitControllerView_Type2.swift
//  ReplaceScrollViewTest
//
//  Created by SeoGiwon on 12/10/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

@IBDesignable
class SplitControllerView_Type2: SplitControllerView {

    func defaultSplitViewFramePixel() {
        let splitViewAlphaFrame = CGRect(x: 0, y: 0, width: splitViewSize.width / 2.0, height: defaultViewHeight)
        
        let splitViewBetaFrame = CGRect(x: splitViewSize.width / 2.0, y: 0, width: splitViewSize.width / 2.0, height: defaultViewHeight)
        
        splitViewAlpha.scrollViewFrame  = splitViewAlphaFrame
        splitViewBeta.scrollViewFrame = splitViewBetaFrame
    }
    

    
    lazy var splitViewAlpha: SplitScrollView = { return SplitScrollView() }()
    lazy var splitViewBeta: SplitScrollView = { return SplitScrollView() }()
    
    lazy var sizeControlAlpha: SplitViewSizeControl = {
        
        let control = SplitViewSizeControl(controlType: .vertical)
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
        self.addSubview(sizeControlAlpha)
        
        setupConstraints()
        defaultSplitViewFramePixel()
        
        splitViewAlpha.image = UIImage(named: "IMG_2190.jpg")
        splitViewBeta.image = UIImage(named: "IMG_2189.jpg")
    }

    func setupConstraints() {
        
        splitViewAlpha.setupSuperviewConstraints(superview: self, size:
            CGSize(width: splitViewSize.width / 2.0,
                   height: defaultViewHeight),
                                                 offset: CGPoint.zero)
        
        
        splitViewBeta.setupSuperviewConstraints(superview: self, size:
            CGSize(width: splitViewSize.width / 2.0,
                   height: defaultViewHeight),
                                                offset:
            CGPoint(x: splitViewSize.width / 2.0, y: 0))
        
        sizeControlAlpha.setupSuperviewConstraints(superview: self, size:
            CGSize(width: 30,
                   height: splitViewSize.height),
                                                   centerOff: CGPoint.zero)
    }
}

extension SplitControllerView_Type2: SplitViewSizeControlProtocol {
    func shouldMove(sizeControl: SplitViewSizeControl, newCenterOff: CGPoint) -> Bool {
        
        if sizeControl === self.sizeControlAlpha {
            
            let newCenterPt = CGPoint(x: self.bounds.midX + newCenterOff.x,
                                      y: self.bounds.midY + newCenterOff.y)
            
            let rect = CGRect(x: 50, y: 0,
                              width: splitViewSize.width - 100,
                              height: splitViewSize.height)
            
            return rect.contains(newCenterPt)
            
        }
        
        return false
    }
    
    func didMove(sizeControl: SplitViewSizeControl, delta: CGPoint) {
        
        if sizeControl === self.sizeControlAlpha {
            
            self.splitViewAlpha.update(sizeDelta: CGSize(width: delta.x, height: 0))
            
            self.splitViewBeta.update(offsetDelta: CGPoint(x: delta.x, y: 0))
            
            self.splitViewBeta.update(sizeDelta: CGSize(width: -delta.x, height: 0))
            
        }
    }
}
