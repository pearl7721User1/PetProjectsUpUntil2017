//
//  PhotoNavigationView.swift
//  MiniatureScrollViewTest
//
//  Created by SeoGiwon on 25/07/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

/**
    PhotoNavigationView is made of a MainNavigationView and a ThumbnailNavigationView. Both of
    them are created and the view hierarchy is set in willMove() function. They both need to know
    which index of the images is showing at the given moment and its updates. Instead of introducing
    models, I just choose to let each of them delegates to each other so that they can notify index
    updates by themselves.
*/
class PhotoNavigationView: UIView {

    enum BackgroundColor {
        case black, white
    }
    
    var viewMode = BackgroundColor.white
    
    var navigationBar: UINavigationBar?
    
    lazy var thumbnailNavigationView: ThumbnailNavigationView = {
        
        let view = ThumbnailNavigationView(with: self.images)
        view.indexOfImages = self.indexOfImages
        
        return view
    }()
    
    var images: [UIImage]!
    var indexOfImages = 0
    
    lazy var mainNavigationView: MainNavigationView = {
        
        let view = MainNavigationView(with: self.images)
        view.backgroundColor = UIColor.white
        view.indexOfImages = self.indexOfImages
        
        return view
    }()
    
    let toolbarView = MyToolbar()

    convenience init(withImages images:[UIImage]) {
        
        self.init(frame: UIScreen.main.bounds)
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
        
        self.addSubview(mainNavigationView)
        toolbarView.addSubview(thumbnailNavigationView)
        self.addSubview(toolbarView)
        
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(toggleBackgroundColor))
        mainNavigationView.addGestureRecognizer(tapGR)
        
        mainNavigationView.interScrollViewDelegate = thumbnailNavigationView
        thumbnailNavigationView.interScrollViewDelegate = mainNavigationView
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainNavigationView.frame = self.bounds
        toolbarView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 94, width: UIScreen.main.bounds.width, height: 94)
        thumbnailNavigationView.frame = CGRect(x: 0, y: 0, width: toolbarView.frame.width, height: 50)
        
        mainNavigationView.backgroundColor = viewMode == .black ? UIColor.black : UIColor.white
    }
    
    func toggleBackgroundColor() {
        let newColor = viewMode == .black ? UIColor.white : UIColor.black
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.mainNavigationView.backgroundColor = newColor
            self.toolbarView.alpha = self.viewMode == .white ? 0.0 : 1.0
            self.navigationBar?.alpha = self.viewMode == .white ? 0.0 : 1.0
            
        }) { (finished) in
            self.viewMode = self.viewMode == .black ? .white : .black
            self.mainNavigationView.updateView()
        }
        
        
    }
}
