//
//  TestViewController.swift
//  MiniatureScrollViewTest
//
//  Created by SeoGiwon on 02/06/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class PhotoNavigationViewController: UIViewController {

    var images: [UIImage] {
        
        if let navigationController = navigationController as? PhotoNavigatior {
            return navigationController.images
        } else {
            return [UIImage]()
        }
    }
    
    lazy var navigationView: PhotoNavigationView = {
        
        let view = PhotoNavigationView(withImages: self.images)
        view.navigationBar = self.navigationController?.navigationBar
        view.indexThatComesFirst = self.indexThatComesFirst
        
        return view
    }()
    
    var indexThatComesFirst = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addSubview(navigationView)
     
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
