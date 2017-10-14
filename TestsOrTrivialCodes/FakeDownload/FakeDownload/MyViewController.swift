//
//  MyViewController.swift
//  FakeDownload
//
//  Created by SeoGiwon on 4/28/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {

    let downloadStatusView = DownloadStatusView()
    
    let waitingView = DownloadWaitingView()
    
     let myView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        self.view.addSubview(downloadStatusView)

        waitingView.frame.origin = CGPoint(x: 0, y: 100)
        self.view.addSubview(waitingView)

        
       
        myView.backgroundColor = UIColor.white
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        let angle: CGFloat = CGFloat(Double.pi)
        rotation.fromValue = 0
        rotation.toValue = angle
        rotation.duration = 1
        rotation.repeatCount = Float.greatestFiniteMagnitude
        
        myView.layer.add(rotation, forKey: nil)
 
        
    
        
//        self.view.addSubview(myView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        downloadStatusView.center = self.view.center
        waitingView.center = self.view.center
        myView.center = self.view.center
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
