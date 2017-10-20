//
//  SecondViewController.swift
//  dsfewrefds
//
//  Created by SeoGiwon on 1/27/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    var snapshotBgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(snapshotBgView)
        snapshotBgView.alpha = 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handler(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: sender.view)
        var percentage = abs(translation.y) / self.view.frame.height //(imgView.frame.height/2.0)
        
        switch sender.state {
            
        case .began: break
            
            
        case .changed:
            
            
            // update interactiveTransition object.
            // Before that, calculate how much percentage do we want to proceed.
            //            interactiveTransition?.update(percentage)
            print("percentage:\(percentage)")
            
//            self.view.alpha = percentage
            snapshotBgView.alpha = (1.0 - percentage)
            self.navigationController?.navigationBar.alpha = percentage
            
            
        case .cancelled, .failed, .ended:
//            self.view.alpha = 1.0
            snapshotBgView.alpha = 0.0
            self.navigationController?.navigationBar.alpha = 1.0

        default: break
            
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
