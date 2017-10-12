//
//  ImageViewController.swift
//  SimplePersistence
//
//  Created by SeoGiwon on 05/08/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    
    var img: UIImage? {
        didSet {
            imgView.image = img
            self.viewWillLayoutSubviews()
        }
    }
    
    let imgView = UIImageView()
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        // Do any additional setup after loading the view.
        scrollView.addSubview(imgView)
        self.view.addSubview(scrollView)
        
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(toggleBackgroundColor))
        self.view.addGestureRecognizer(tapGR)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.frame = self.view.frame
        imgView.sizeToFit()
        imgView.frame.origin = CGPoint.zero
        scrollView.contentSize = CGSize(width: img?.size.width ?? 0, height: img?.size.height ?? 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleBackgroundColor() {
        let newColor = self.view.backgroundColor == UIColor.black ? UIColor.white : UIColor.black
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = newColor
            self.navigationController?.navigationBar.alpha = newColor == UIColor.black ? 0.0 : 1.0
            
        }) { (finished) in
            
        }
        
        
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
