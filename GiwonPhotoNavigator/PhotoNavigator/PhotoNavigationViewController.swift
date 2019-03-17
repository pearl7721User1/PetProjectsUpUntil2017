//
//  TestViewController.swift
//  MiniatureScrollViewTest
//
//  Created by SeoGiwon on 02/06/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit


class PhotoNavigationViewController: UIViewController {

    /// This computed property brings image resources defined in MyNavigationController
    var images: [UIImage] {
        
        if let navigationController = navigationController as? MyNavigationController {
            return navigationController.images
        } else {
            return [UIImage]()
        }
    }
    
    /// This view takes the window's frame by itself and requires image index to show from 'images'
    lazy var navigationView: PhotoNavigationView = {
        
        let view = PhotoNavigationView(withImages: self.images)
        view.navigationBar = self.navigationController?.navigationBar
        view.indexOfImages = self.indexOfImages
        
        return view
    }()
    
    /// This property's value can be configured by the creator of this view controller
    var indexOfImages = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addSubview(navigationView)
     
    }


}
