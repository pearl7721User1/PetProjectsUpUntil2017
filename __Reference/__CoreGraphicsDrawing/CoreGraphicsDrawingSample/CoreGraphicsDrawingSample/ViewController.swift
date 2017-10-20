//
//  ViewController.swift
//  CoreGraphicsDrawingSample
//
//  Created by SeoGiwon on 4/23/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

/*
    let downloading: DownloadingView = DownloadingView()
    let readyForDownloadView: ReadyForDownloadView = {
       
        let readyForDownloadImage = ReadyForDownloadView.image()
        let theView = ReadyForDownloadView()
        theView.layer.contents = readyForDownloadImage.cgImage
        
        return theView
    }()
    
    let askingForDownloadView: UIImageView = {
        
        let askingForDownloadImage = NotReadyForDownloadView.image()
        let imageView = UIImageView(image: askingForDownloadImage)
        
        return imageView
    }()
*/
    let downloadStatusView = DownloadStatusView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.view.addSubview(downloadStatusView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        downloadStatusView.center = self.view.center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

