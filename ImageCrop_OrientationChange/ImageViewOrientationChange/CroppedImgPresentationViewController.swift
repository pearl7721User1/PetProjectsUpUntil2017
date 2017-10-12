//
//  CroppedImgPresentationViewController.swift
//  ImageViewOrientationChange
//
//  Created by SeoGiwon on 3/2/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class CroppedImgPresentationViewController: UIViewController {
    // This view controller displays cropped image along with crop rect position, size.
    
    // view for cropped image
    @IBOutlet weak var croppedImgView: UIImageView!
    
    // label for original image size
    @IBOutlet weak var originalImgSizeLB: UILabel!
    
    // label for cropped image size
    @IBOutlet weak var croppedImgSizeLB: UILabel!
    
    // label for cropped image position
    @IBOutlet weak var croppedImgOriginLB: UILabel!
    
    // models for either image or labels
    var img: UIImage?
    var originalImgSize: CGSize?
    var croppedImgOrigin: CGPoint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        croppedImgView.image = img
        
        if let theImg = img, let origin = croppedImgOrigin, let originalSize = originalImgSize {
            croppedImgSizeLB.text = "(\(theImg.size.width) , \(theImg.size.height))"
            croppedImgOriginLB.text = "(\(origin.x) , \(origin.y))"
            originalImgSizeLB.text = "(\(originalSize.width) , \(originalSize.height))"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeVCBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }


}
