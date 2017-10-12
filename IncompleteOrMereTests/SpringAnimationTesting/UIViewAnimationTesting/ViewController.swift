//
//  ViewController.swift
//  UIViewAnimationTesting
//
//  Created by SeoGiwon on 11/28/16.
//  Copyright © 2016 SeoGiwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var view1: UIView?
    var view2: UIView?
    
    
    @IBAction func action(_ sender: UIButton) {
        
        self.view2 = UIView.init(frame: CGRect.init(x: 30, y: 230, width: 100, height: 100))
        view2?.backgroundColor = UIColor.green
        self.view.addSubview(view2!)
        view2?.alpha = 0.0
        /*
        UIView.animate(withDuration: 1.0, animations: {
            
            self.view2?.alpha = 1.0
            self.view2?.center = (self.view1?.center)!
            
        })
        */
/*
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations:
        {
            self.view2?.alpha = 1.0
            self.view2?.center = (self.view1?.center)!
            
        }, completion:nil)
*/
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.0, options: [], animations:
            {
                self.view2?.alpha = 1.0
                self.view2?.center = (self.view1?.center)!
        }, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view1 = UIView.init(frame: CGRect.init(x: 30, y: 30, width: 100, height: 100))
        view1?.backgroundColor = UIColor.red
        self.view.addSubview(view1!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

