//
//  ViewController.swift
//  dsfewrefds
//
//  Created by SeoGiwon on 1/27/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let newVC = segue.destination as! SecondViewController
        
        /*
        let navigationbarSnapshot = self.navigationController?.navigationBar.snapshotView(afterScreenUpdates: false)
        let viewSnapshot = self.view.snapshotView(afterScreenUpdates: false)
        navigationbarSnapshot!.frame.origin = CGPoint(x: 0, y: 64)
        
        let view = UIView(frame: self.view.frame)
        view.addSubview(navigationbarSnapshot!)
        view.addSubview(viewSnapshot!)
 
        print("\(navigationbarSnapshot!.frame.origin.x) \(navigationbarSnapshot!.frame.origin.y) \(navigationbarSnapshot!.frame.size.width) \(navigationbarSnapshot!.frame.size.height)")
        print("\(viewSnapshot!.frame.origin.x) \(viewSnapshot!.frame.origin.y) \(viewSnapshot!.frame.size.width) \(viewSnapshot!.frame.size.height)")
 */
        
        newVC.snapshotBgView = screenShotMethod()//self.view.snapshotView(afterScreenUpdates: false)
    }
    
    func screenShotMethod() -> UIView {
        
        
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imgView = UIImageView(image: screenshot)
        let view = UIView(frame: self.view.frame)
        imgView.frame = view.bounds
        view.addSubview(imgView)
        
            return view
    }
}

