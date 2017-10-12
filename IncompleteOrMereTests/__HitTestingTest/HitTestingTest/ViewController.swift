//
//  ViewController.swift
//  HitTestingTest
//
//  Created by SeoGiwon on 3/2/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var subView1 = Level1View()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        subView1.frame = CGRect(x: 50, y: 50, width: 250, height: 250)
        subView1.backgroundColor = UIColor.blue
        self.view.addSubview(subView1)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

