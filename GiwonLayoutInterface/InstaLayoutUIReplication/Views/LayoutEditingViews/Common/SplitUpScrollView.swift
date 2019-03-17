//
//  ImageContainerScrollView.swift
//  ReplaceScrollViewTest
//
//  Created by SeoGiwon on 24/08/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class SplitUpScrollView: UIScrollView {
    
    
    /**
     The image is contained in this scroll view, and it behaves as if it is contained in
     ScaleAspectFill mode.
    */
    var image: UIImage? {
        didSet {
            imageView.image = image
            updateImageViewConstraints()
        }
    }
    
    /**
        This property needs to be constantly updated whenever the size of this view's frame is changed,
        which is caused by user's interaction with the size control. Otherwise, this view's image
        containment will show unruly behaviors.
    */
    var imageFrameSize: CGSize? {
        didSet {
            updateImageViewConstraints()
        }
    }
    
    /**
     It takes 'image', 'imageFrameSize' as parameters to come up with the size that the image view fits
     in ContentAspectFill mode. As a result, the constraints of the image view is updated, and it zooms
     in/out by itself.
    */
    private var imageSizeAsContentAspectFill: CGSize {
        
        // takes the size of the image frame
        let sizeOfTheImageFrame = imageFrameSize ?? CGSize.zero
        
        // come up with the size that the image view will fill
        return image?.scaleAspectFillSize(against: sizeOfTheImageFrame) ?? CGSize.zero
    }
    
    /*
     view hierarchy:
        self(scrollview)
                            - imageView
    */
    fileprivate var imageView = UIImageView()
    
    private var imageViewWidthConstraint = NSLayoutConstraint()
    private var imageViewHeightConstraint = NSLayoutConstraint()
    
    private var viewWidthConstraint = NSLayoutConstraint()
    private var viewHeightConstraint = NSLayoutConstraint()
    private var viewLeftConstraint = NSLayoutConstraint()
    private var viewTopConstraint = NSLayoutConstraint()
    
    // MARK: - Initializer
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
        self.addSubview(imageView)
        
        configureView()
        setupImageViewConstraints()
    }
    
    private func configureView() {
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.clipsToBounds = true
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 4.0
        self.delegate = self
    }
    
    
    // MARK: - Setting AutoLayout
    /// SplitUpScrollView installs constraints by itself by calling this function.
    func setupConstraints(superview: UIView, size: CGSize, offset: CGPoint) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        viewTopConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy:.equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: offset.y)
        viewLeftConstraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy:.equal, toItem: superview, attribute: .left, multiplier: 1.0, constant: offset.x)
        viewWidthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy:.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: size.width)
        viewHeightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy:.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: size.height)
        
        NSLayoutConstraint.activate([viewTopConstraint, viewLeftConstraint, viewWidthConstraint, viewHeightConstraint])
        
    }
    
    /// SplitUpScrollView updates its position by given CGPoint value
    func update(offsetDelta: CGPoint) {
        
        viewLeftConstraint.constant += offsetDelta.x
        viewTopConstraint.constant += offsetDelta.y
        
    }
    
    /// SplitUpScrollView updates its size by given CGSize value
    func update(sizeDelta: CGSize) {
        
        viewWidthConstraint.constant += sizeDelta.width
        viewHeightConstraint.constant += sizeDelta.height
        
        imageFrameSize = CGSize(width: (imageFrameSize?.width ?? 0) + sizeDelta.width,
                                       height: (imageFrameSize?.height ?? 0) + sizeDelta.height)
    }
    
    /**
        It installs constraints for imageview against its parent view(SplitUpScrollView) for the first
        time ever. This function must not be called more than once.
    */
    private func setupImageViewConstraints() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
        imageViewWidthConstraint = NSLayoutConstraint(item: self.imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: imageSizeAsContentAspectFill.width)
        
        imageViewHeightConstraint = NSLayoutConstraint(item: self.imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: imageSizeAsContentAspectFill.height)
        
        NSLayoutConstraint.activate([imageViewHeightConstraint, imageViewWidthConstraint])
        
    }
    
    /**
        It updates the very constraints about how much the size of the image view will be in
        SplitUpScrollView. If the given image view size is bigger than SplitUpScrollView's bounds, the
        image view zooms in, otherwise, zooms out by itself.
    */
    private func updateImageViewConstraints() {
        
        imageViewWidthConstraint.constant = imageSizeAsContentAspectFill.width + 0.25
        imageViewHeightConstraint.constant = imageSizeAsContentAspectFill.height + 0.25

        self.layoutIfNeeded()
    }
}

extension SplitUpScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
