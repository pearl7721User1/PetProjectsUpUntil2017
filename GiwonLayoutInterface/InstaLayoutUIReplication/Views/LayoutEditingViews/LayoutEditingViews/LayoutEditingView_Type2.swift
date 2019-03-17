//
//  SplitControllerView_Type2.swift
//  ReplaceScrollViewTest
//
//  Created by SeoGiwon on 12/10/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

/**
 LayoutEditingView_Type2 is a view that has two views(splitViewAlpha, splitViewBeta, and
 one size control(sizeControlAlpha).
 |    |     |
 |    |     |
 |    |     |
 |    |     |
 |    |     |
 
 */
class LayoutEditingView_Type2: LayoutEditingView {

    override func setDefaultImageViewFrameOnSplitUpScrollView() {
        let splitViewAlphaFrame = CGRect(x: 0, y: 0, width: splitViewSize.width / 2.0, height: defaultViewHeight)
        
        let splitViewBetaFrame = CGRect(x: splitViewSize.width / 2.0, y: 0, width: splitViewSize.width / 2.0, height: defaultViewHeight)
        
        splitViewAlpha.imageFrameSize  = splitViewAlphaFrame.size
        splitViewBeta.imageFrameSize = splitViewBetaFrame.size
    }
    

    
    lazy var splitViewAlpha: SplitUpScrollView = { return SplitUpScrollView() }()
    lazy var splitViewBeta: SplitUpScrollView = { return SplitUpScrollView() }()
    
    lazy var sizeControlAlpha: LayoutEditingSizeControl = {
        
        let control = LayoutEditingSizeControl(controlType: .vertical)
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
        self.addSubview(sizeControlAlpha)
        
        setupConstraints()
        setDefaultImageViewFrameOnSplitUpScrollView()
        
        splitViewAlpha.image = UIImage(named: "IMG_2190.jpg")
        splitViewBeta.image = UIImage(named: "IMG_2189.jpg")
    }

    // setup constraints for all the subviews 
    private func setupConstraints() {
        
        splitViewAlpha.setupConstraints(superview: self, size:
            CGSize(width: splitViewSize.width / 2.0,
                   height: defaultViewHeight),
                                                 offset: CGPoint.zero)
        
        splitViewBeta.setupConstraints(superview: self, size:
            CGSize(width: splitViewSize.width / 2.0,
                   height: defaultViewHeight),
                                                offset:
            CGPoint(x: splitViewSize.width / 2.0, y: 0))
        
        sizeControlAlpha.setupConstraints(superview: self, size:
            CGSize(width: 30,
                   height: splitViewSize.height),
                                                   centerOff: CGPoint.zero)
    }
}

extension LayoutEditingView_Type2: LayoutEditingSizeControlProtocol {
    func shouldMove(sizeControl: LayoutEditingSizeControl, delta: CGPoint, currentCenterOffset: CGPoint) -> Bool {
        
        /*
         The size control must stay in the boundRect. Otherwise, the
         movement must not be allowed.
         */
        
        let newCenterWillBe = CGPoint(x: delta.x + currentCenterOffset.x + self.bounds.midX,
                                      y: delta.y + currentCenterOffset.y + self.bounds.midY)
        var boundRect = CGRect.zero
        
        if sizeControl === self.sizeControlAlpha {
            boundRect = CGRect(x: 50, y: 0,
                              width: splitViewSize.width - 100,
                              height: splitViewSize.height)
        } else {
            return false
        }
        
        return boundRect.contains(newCenterWillBe)
    }
    
    func didMove(sizeControl: LayoutEditingSizeControl, delta: CGPoint) {
        
        if sizeControl === self.sizeControlAlpha {
            
            self.splitViewAlpha.update(sizeDelta: CGSize(width: delta.x, height: 0))
            
            self.splitViewBeta.update(offsetDelta: CGPoint(x: delta.x, y: 0))
            
            self.splitViewBeta.update(sizeDelta: CGSize(width: -delta.x, height: 0))
            
        }
    }
}
