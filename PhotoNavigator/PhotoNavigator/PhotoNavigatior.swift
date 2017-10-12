//
//  PhotoNavigatior.swift
//  MiniatureScrollViewTest
//
//  Created by SeoGiwon on 26/07/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class PhotoNavigatior: UINavigationController {

    let images: [UIImage] = {
        
        return [UIImage(named: "IMG_2188.jpg")!, UIImage(named: "IMG_2189.jpg")!
            , UIImage(named: "IMG_2190.jpg")!, UIImage(named: "IMG_2191.jpg")!
            , UIImage(named: "IMG_2192.jpg")!, UIImage(named: "IMG_2193.jpg")!
            , UIImage(named: "IMG_2194.jpg")!, UIImage(named: "IMG_2195.jpg")!
            , UIImage(named: "IMG_2196.jpg")!, UIImage(named: "IMG_2197.jpg")!
            , UIImage(named: "IMG_2198.jpg")!, UIImage(named: "IMG_2199.jpg")!
            , UIImage(named: "IMG_2200.jpg")!, UIImage(named: "IMG_2201.jpg")!
            , UIImage(named: "IMG_2202.jpg")!, UIImage(named: "IMG_2203.jpg")!
            , UIImage(named: "IMG_2204.jpg")!, UIImage(named: "IMG_2205.jpg")!
            , UIImage(named: "IMG_2206.jpg")!, UIImage(named: "IMG_2207.jpg")!
            , UIImage(named: "IMG_2208.jpg")!]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
