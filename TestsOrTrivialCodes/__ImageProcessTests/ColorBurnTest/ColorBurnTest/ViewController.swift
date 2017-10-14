//
//  ViewController.swift
//  ColorBurnTest
//
//  Created by SeoGiwon on 14/07/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let imgView = UIImageView(frame: CGRect(x: 100, y: 200, width: 160, height: 120))
        let img = UIImage(named: "GreenSwirl.png")
        
        imgView.image = img?.colorizedByGiwon(with: UIColor.init(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0))
        
        self.view.addSubview(imgView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

