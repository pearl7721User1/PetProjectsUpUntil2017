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
    
    var indexOfImages = 0
    
    /**
        viewWidth must be known from the beginning so that the frame of rightSeparatorView,
        leftSeparatorView are calculated before the installed constraints take effect.
    */
    let viewWidth = UIScreen.main.bounds.width

    /// a view that separates the on-screen image view from the right off-screen image view
    fileprivate lazy var rightSeparatorView: UIView = {
    
        let view = UIView()
        view.backgroundColor = self.backgroundColor
        view.frame = CGRect(x: 0, y: 0, width: 40, height: UIScreen.main.bounds.height)
        return view
    }()
    
    /// a view that separates the on-screen image view from the left off-screen image view
    fileprivate lazy var leftSeparatorView: UIView = {
        
        let view = UIView()
        view.backgroundColor = self.backgroundColor
        view.frame = CGRect(x: 0, y: 0, width: 40, height: UIScreen.main.bounds.height)
        return view
    }()
    
    
    fileprivate var oldIndex: Int = 0
    fileprivate var oldIndex2: Int = 0
    
    fileprivate var rightSeparatorOrigin = CGPoint.zero
    fileprivate var leftSeparatorOrigin = CGPoint.zero

    
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
        
        scrollView.addSubview(rightSeparatorView)
        scrollView.addSubview(leftSeparatorView)
        
        // init seperator views' positions
        moveSeparatorView()
        
        // move the content offset for the first time only to have the selected index of image views
        // show on-screen
        let theContentOffset = CGPoint(x: viewWidth * CGFloat(indexOfImages), y: 0)
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
        
        var targetIndex: Int = Int(round(scrollView.contentOffset.x / viewWidth))
        if (targetIndex < 0) {
            targetIndex = 0
        }
        if (targetIndex > kMaxIndex) {
            targetIndex = kMaxIndex
        }

        return targetIndex
    }
    
    func moveSeparatorView() {
        let index = scrollViewSubViewIndex()
        rightSeparatorOrigin = CGPoint(x:scrollView.subviews[index].frame.maxX, y:scrollView.subviews[index].frame.minY)
        leftSeparatorOrigin = CGPoint(x:scrollView.subviews[index].frame.minX-40, y:scrollView.subviews[index].frame.minY)
        
        rightSeparatorView.frame.origin = rightSeparatorOrigin
        leftSeparatorView.frame.origin = leftSeparatorOrigin
        
       
    }
    
    func updateView() {
        rightSeparatorView.backgroundColor = self.backgroundColor
        leftSeparatorView.backgroundColor = self.backgroundColor
    }
}

extension MainNavigationView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        oldIndex = scrollViewSubViewIndex()
        oldIndex2 = scrollViewSubViewIndex()
        
        moveSeparatorView()
        
        print("sepeartor: \(rightSeparatorOrigin.x) \(leftSeparatorOrigin.x)")
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // -100% ~ 100%
        let oldContentOffset = CGPoint(x: CGFloat(oldIndex) * viewWidth, y:0)
        let newContentOffset = scrollView.contentOffset
        
        let XTranslation = (newContentOffset.x - oldContentOffset.x) / viewWidth

        print(XTranslation)
        
        print("sepeartor: \(rightSeparatorOrigin.x) \(leftSeparatorOrigin.x)")
        
        if (XTranslation > 0) {
            rightSeparatorView.frame.origin.x = rightSeparatorOrigin.x - XTranslation * 40
        } else {
            leftSeparatorView.frame.origin.x = leftSeparatorOrigin.x - XTranslation * 40
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
        moveSeparatorView()
    }
}
