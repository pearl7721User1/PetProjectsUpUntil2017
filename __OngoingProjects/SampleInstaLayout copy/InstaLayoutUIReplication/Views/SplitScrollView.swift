//
//  ImageContainerScrollView.swift
//  ReplaceScrollViewTest
//
//  Created by SeoGiwon on 24/08/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class SplitScrollView: UIScrollView {

    enum SplitType {
        case vertical, horizontal, both
    }
    
    var image: UIImage? {
        didSet {
            imageView.image = image
            updateImageScale()
        }
    }
    
    var scrollViewFrame: CGRect? {
        didSet {
            updateImageScale()
        }
    }
    
    private var imageRect: CGRect {
        
        
        let splitViewRect = CGRect(origin: CGPoint.zero, size: scrollViewFrame?.size ?? CGSize.zero)
        let imageViewRect = (image?.getContentAspectFillImgViewRect(fromRect: splitViewRect)) ?? CGRect.zero
        return imageViewRect
    }
    
    fileprivate var imageView = UIImageView()
    
    // subview constraints
    private var imageViewWidthConstraint = NSLayoutConstraint()
    private var imageViewHeightConstraint = NSLayoutConstraint()
    
    // self constraints
    private var viewWidthConstraint = NSLayoutConstraint()
    private var viewHeightConstraint = NSLayoutConstraint()
    private var viewLeftConstraint = NSLayoutConstraint()
    private var viewTopConstraint = NSLayoutConstraint()
    
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
        self.addSubview(imageView)
        
        configureView()
        setupConstraints()
    }
    
    private func configureView() {
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.clipsToBounds = true
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 4.0
        self.delegate = self
    }
    
    func setupSuperviewConstraints(superview: UIView, size: CGSize, offset: CGPoint) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        viewTopConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy:.equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: offset.y)
        viewLeftConstraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy:.equal, toItem: superview, attribute: .left, multiplier: 1.0, constant: offset.x)
        viewWidthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy:.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: size.width)
        viewHeightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy:.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: size.height)
        
        NSLayoutConstraint.activate([viewTopConstraint, viewLeftConstraint, viewWidthConstraint, viewHeightConstraint])
        
    }
    
    func update(offsetDelta: CGPoint) {
        
        viewLeftConstraint.constant += offsetDelta.x
        viewTopConstraint.constant += offsetDelta.y
        
        scrollViewFrame?.origin = CGPoint(x: (scrollViewFrame?.origin.x ?? 0) + offsetDelta.x,
                                          y: (scrollViewFrame?.origin.y ?? 0) + offsetDelta.y)
        
    }
    
    func update(sizeDelta: CGSize) {
        
        viewWidthConstraint.constant += sizeDelta.width
        viewHeightConstraint.constant += sizeDelta.height
        
        scrollViewFrame?.size = CGSize(width: (scrollViewFrame?.size.width ?? 0) + sizeDelta.width,
                                       height: (scrollViewFrame?.size.height ?? 0) + sizeDelta.height)
    }
    
    private func setupConstraints() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
        imageViewWidthConstraint = NSLayoutConstraint(item: self.imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: imageRect.size.width)
        
        imageViewHeightConstraint = NSLayoutConstraint(item: self.imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: imageRect.size.height)
        
        NSLayoutConstraint.activate([imageViewHeightConstraint, imageViewWidthConstraint])
        
    }
    
    private func updateImageScale() {
        
        imageViewWidthConstraint.constant = imageRect.size.width + 0.25
        imageViewHeightConstraint.constant = imageRect.size.height + 0.25

        self.layoutIfNeeded()
    }
}

extension SplitScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
