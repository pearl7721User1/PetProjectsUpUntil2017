//
//  MyScrollView.swift
//  MiniatureScrollViewTest
//
//  Created by SeoGiwon on 02/06/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

protocol InterScrollViewProtocol: class {
    func hasMovedToNewIndex(index: Int)
}


class MainNavigationView: UIView {

    weak var interScrollViewDelegate: InterScrollViewProtocol?
    
    var indexThatComesFirst = 0

    fileprivate lazy var rightBorderView: UIView = {
    
        let view = UIView()
        view.backgroundColor = self.backgroundColor
        view.frame = CGRect(x: 0, y: 0, width: 40, height: UIScreen.main.bounds.height)
        return view
    }()
    
    fileprivate lazy var leftBorderView: UIView = {
        
        let view = UIView()
        view.backgroundColor = self.backgroundColor
        view.frame = CGRect(x: 0, y: 0, width: 40, height: UIScreen.main.bounds.height)
        return view
    }()
    
    
    fileprivate var oldIndex: Int = 0
    fileprivate var oldIndex2: Int = 0
    
    fileprivate var rightBorderOrigin = CGPoint.zero
    fileprivate var leftBorderOrigin = CGPoint.zero

    var contentOffsetXPercentage: CGPoint {
        let x = (scrollView.contentOffset.x / scrollView.contentSize.width) * 100.0
        let y = (scrollView.contentOffset.y / scrollView.contentSize.height) * 100.0
        
        return CGPoint(x: x, y: y)
    }
    
    fileprivate var images: [UIImage]!
    fileprivate var scrollView = UIScrollView()

    convenience init(with images: [UIImage]) {
        
        self.init(frame: CGRect.zero)
        self.images = images
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        setupScrollView()
        
        setupConstraints()
        
        
        scrollView.addSubview(rightBorderView)
        scrollView.addSubview(leftBorderView)
        
        moveBorderView()
        
        
        let theContentOffset = CGPoint(x: UIScreen.main.bounds.width * CGFloat(indexThatComesFirst), y: 0)
        
        self.scrollView.setContentOffset(theContentOffset, animated: false)
        
    }
    
    private func setupConstraints() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        
        for index in 1..<scrollView.subviews.count {
            
            let leftSubView = scrollView.subviews[index-1]
            let rightSubView = scrollView.subviews[index]
            rightSubView.translatesAutoresizingMaskIntoConstraints = false
            rightSubView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            rightSubView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
            rightSubView.leftAnchor.constraint(equalTo: leftSubView.rightAnchor, constant:0).isActive = true
            rightSubView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
            
            
            if (index == scrollView.subviews.count - 1) {
                rightSubView.rightAnchor.constraint(lessThanOrEqualTo: scrollView.rightAnchor, constant: 0).isActive = true
            }
            
            if (index == 1) {
                leftSubView.translatesAutoresizingMaskIntoConstraints = false
                
                leftSubView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
                leftSubView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
                leftSubView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
                leftSubView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
                
            }
        }
        
    }
    
    private func setupScrollView() {
        
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = true
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width * CGFloat(images?.count ?? 0), height: UIScreen.main.bounds.height)
        self.addSubview(scrollView)
        
        
        if let images = images {
            for index in 0..<images.count {
                
                let oneView = MainNavigationItem()
                oneView.image = images[index]
                scrollView.addSubview(oneView)
            }
        }
        
        
    }
    
    func scrollViewSubViewIndex() -> Int {
        let kMaxIndex = images?.count ?? 0
        
        var targetIndex: Int = Int(round(scrollView.contentOffset.x / UIScreen.main.bounds.width))
        if (targetIndex < 0) {
            targetIndex = 0
        }
        if (targetIndex > kMaxIndex) {
            targetIndex = kMaxIndex
        }

        return targetIndex
    }
    
    func moveBorderView() -> (CGPoint, CGPoint) {
        let index = scrollViewSubViewIndex()
        let rightBorderViewOrigin = CGPoint(x:scrollView.subviews[index].frame.maxX, y:scrollView.subviews[index].frame.minY)
        let leftBorderViewOrigin = CGPoint(x:scrollView.subviews[index].frame.minX-40, y:scrollView.subviews[index].frame.minY)
        
        rightBorderView.frame.origin = rightBorderViewOrigin
        leftBorderView.frame.origin = leftBorderViewOrigin
        
        return (leftBorderViewOrigin, rightBorderViewOrigin)
    }
    
    func updateView() {
        rightBorderView.backgroundColor = self.backgroundColor
        leftBorderView.backgroundColor = self.backgroundColor
    }
}

extension MainNavigationView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        oldIndex = scrollViewSubViewIndex()
        oldIndex2 = scrollViewSubViewIndex()
        
        let result = moveBorderView()
        leftBorderOrigin = result.0
        rightBorderOrigin = result.1
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // -100% ~ 100%
        
        let oldContentOffset = CGPoint(x: CGFloat(oldIndex) * scrollView.frame.width, y:0)
        let newContentOffset = scrollView.contentOffset
        
        print("oldIndex:\(oldIndex)")
        
        let XTranslation = (newContentOffset.x - oldContentOffset.x) / scrollView.frame.width
        print(XTranslation)
        
        if (XTranslation > 0) {
            rightBorderView.frame.origin.x = rightBorderOrigin.x - XTranslation * 40
        } else {
            leftBorderView.frame.origin.x = leftBorderOrigin.x - XTranslation * 40
        }
        
        let newIndex = scrollViewSubViewIndex()
        

        if (oldIndex2 != newIndex) {
            oldIndex2 = newIndex
            interScrollViewDelegate?.hasMovedToNewIndex(index: newIndex)
        }

    }
}

extension MainNavigationView: InterScrollViewProtocol {
    func hasMovedToNewIndex(index: Int) {
        
        let newContentOffset = CGPoint(x: CGFloat(index) * scrollView.bounds.size.width, y: 0)
        scrollView.setContentOffset(newContentOffset, animated: false)
        moveBorderView()
    }
}
