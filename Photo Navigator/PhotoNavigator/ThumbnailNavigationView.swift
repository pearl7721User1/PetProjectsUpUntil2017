//
//  MyScrollView.swift
//  MiniatureScrollViewTest
//
//  Created by SeoGiwon on 02/06/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class ThumbnailNavigationView: UIView {

    weak var interScrollViewDelegate: InterScrollViewProtocol?
    
    var indexThatComesFirst = 0
    
    fileprivate var leftConstraint: NSLayoutConstraint?
    fileprivate var itemsTotal: Int {
        return images.count
    }
    
    fileprivate var scrollView = UIScrollView()
    fileprivate var images: [UIImage]!
    fileprivate var oldIndex: Int = 0
    fileprivate var isScrolling = false
    
    fileprivate var focusedIndex: Int? {
        didSet {
            if let index = focusedIndex {
                let thumbnailNavigationItem = scrollView.subviews[index] as! ThumbnailNavigationItem
                thumbnailNavigationItem.expand()
                
                leftConstraint?.constant = ThumbnailNavigationItem.wSpacing/2.0 - thumbnailNavigationItem.leftConstraintOffset
                
            } else {
                if let index = oldValue {
                    let thumbnailNavigationItem = scrollView.subviews[index] as! ThumbnailNavigationItem
                    thumbnailNavigationItem.shrink()
                    
                    leftConstraint?.constant = ThumbnailNavigationItem.wSpacing/2.0

                }
            }
            
            UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
                self.layoutIfNeeded()
                
            }, completion: nil)
            
            
        }
    }
    
    fileprivate var contentOffsetXPercentage: CGPoint {
        let x = (scrollView.contentOffset.x / scrollView.contentSize.width) * 100.0
        let y = (scrollView.contentOffset.y / scrollView.contentSize.height) * 100.0
        
        return CGPoint(x: x, y: y)
    }


    convenience init(with images: [UIImage]) {

        self.init(frame: CGRect.zero)
        self.images = images
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        self.clipsToBounds = true
        
        setupScrollView()
        
        focusedIndex = 0
        
        let newContentOffset = CGPoint(x: self.scrollView.bounds.size.width * CGFloat(indexThatComesFirst), y: 0)
        self.scrollView.setContentOffset(newContentOffset, animated: false)
        
        focusedIndex = indexThatComesFirst
    }
    
    private func setupScrollView() {
        
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        self.addSubview(scrollView)
        
        for index in 0..<itemsTotal {
            
            let oneView = ThumbnailNavigationItem(with: images[index])
            scrollView.addSubview(oneView)
        }
        
        setupConstraints()
        

    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if (self.bounds.contains(point)) {
            return scrollView
        }
        else { return nil }

        
    }

    func setupConstraints() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.widthAnchor.constraint(equalToConstant: ThumbnailNavigationItem.itemSize.width).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: ThumbnailNavigationItem.itemSize.height).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        for index in 1..<scrollView.subviews.count {
            
            let leftSubView = scrollView.subviews[index-1]
            let rightSubView = scrollView.subviews[index]
            rightSubView.translatesAutoresizingMaskIntoConstraints = false
            
            
            rightSubView.widthAnchor.constraint(equalToConstant: ThumbnailNavigationItem.itemSize.width - ThumbnailNavigationItem.wSpacing).isActive = true
            rightSubView.constraints[0].identifier = ThumbnailNavigationItem.widthConstraintIdentifier

            rightSubView.heightAnchor.constraint(equalToConstant: ThumbnailNavigationItem.itemSize.height - ThumbnailNavigationItem.hSpacing).isActive = true
            rightSubView.leftAnchor.constraint(equalTo: leftSubView.rightAnchor, constant: ThumbnailNavigationItem.wSpacing).isActive = true
            rightSubView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: ThumbnailNavigationItem.hSpacing/2.0).isActive = true
            
            if (index == scrollView.subviews.count - 1) {
                rightSubView.rightAnchor.constraint(lessThanOrEqualTo: scrollView.rightAnchor, constant: -ThumbnailNavigationItem.wSpacing/2.0).isActive = true

            }
            
            if (index == 1) {
                leftSubView.translatesAutoresizingMaskIntoConstraints = false
                
                let constraint = NSLayoutConstraint(item: leftSubView, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1.0, constant: ThumbnailNavigationItem.wSpacing/2.0)
                leftConstraint = constraint
                NSLayoutConstraint.activate([constraint])
                
                
                leftSubView.widthAnchor.constraint(equalToConstant: ThumbnailNavigationItem.itemSize.width - ThumbnailNavigationItem.wSpacing).isActive = true
                leftSubView.constraints[0].identifier = ThumbnailNavigationItem.widthConstraintIdentifier
                
                leftSubView.heightAnchor.constraint(equalToConstant: ThumbnailNavigationItem.itemSize.height - ThumbnailNavigationItem.hSpacing).isActive = true
                
                
                leftSubView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: ThumbnailNavigationItem.hSpacing/2.0).isActive = true
            }
        }

    }
  
    func scrollViewSubViewIndex() -> Int {
        let kMaxIndex = images?.count ?? 0
        
        var targetIndex: Int = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        if (targetIndex < 0) {
            targetIndex = 0
        }
        if (targetIndex > kMaxIndex) {
            targetIndex = kMaxIndex
        }
        
        return targetIndex
    }

}

extension ThumbnailNavigationView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        focusedIndex = nil
        oldIndex = scrollViewSubViewIndex()
        
        isScrolling = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        focusedIndex = scrollViewSubViewIndex()
        
        isScrolling = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let newIndex = scrollViewSubViewIndex()
        
        if (oldIndex != newIndex) {
            oldIndex = newIndex
            if isScrolling {
                interScrollViewDelegate?.hasMovedToNewIndex(index: newIndex)
            }
        }
    }
}

extension ThumbnailNavigationView:InterScrollViewProtocol {
    func hasMovedToNewIndex(index: Int) {
        
        guard let oldIndex = self.focusedIndex else { return }
        
        let newIndex = index
        
        
        // shut down the old index
        let thumbnailNavigationItem = scrollView.subviews[oldIndex] as! ThumbnailNavigationItem
        thumbnailNavigationItem.shrink()
        leftConstraint?.constant = ThumbnailNavigationItem.wSpacing/2.0
        
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
            self.layoutIfNeeded()
            
            let newContentOffset = CGPoint(x: CGFloat(index) * self.scrollView.bounds.size.width, y: 0)
            self.scrollView.setContentOffset(newContentOffset, animated: false)
            
            
        }, completion: {(finished: Bool) -> (Void) in
            
        })
        
        // at the same time open the new index
        self.focusedIndex = newIndex
        

        
    }
}
