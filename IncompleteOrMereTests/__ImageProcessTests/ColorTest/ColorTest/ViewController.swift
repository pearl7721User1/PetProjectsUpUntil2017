//
//  ViewController.swift
//  ColorTest
//
//  Created by SeoGiwon on 06/06/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        yellowColor()

        purpleColor()
    }
    
    func yellowColor() {
        let yellowColor = UIColor.yellow
        var rgb:[CGFloat] = [0.0, 0.0, 0.0]
        
        yellowColor.getRed(&rgb[0], green: &rgb[1], blue: &rgb[2], alpha: nil)
        
        print("yellowColor:")
        print(rgb[0])
        print(rgb[1])
        print(rgb[2])
    }
    
    func magentaColor() {
        let magentaColor = UIColor.magenta
        var rgb:[CGFloat] = [0.0, 0.0, 0.0]
        
        magentaColor.getRed(&rgb[0], green: &rgb[1], blue: &rgb[2], alpha: nil)
        
        print("magentaColor:")
        print(rgb[0])
        print(rgb[1])
        print(rgb[2])
    }
    
    func purpleColor() {
        
        let purpleColor = UIColor.purple
        var rgb:[CGFloat] = [0.0, 0.0, 0.0]
        
        purpleColor.getRed(&rgb[0], green: &rgb[1], blue: &rgb[2], alpha: nil)
        
        print("purpleColor:")
        print(rgb[0])
        print(rgb[1])
        print(rgb[2])

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

