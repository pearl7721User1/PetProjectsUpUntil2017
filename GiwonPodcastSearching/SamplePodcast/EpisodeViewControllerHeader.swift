//
//  EpisodeViewControllerHeader.swift
//  SamplePodcast
//
//  Created by SeoGiwon on 20/10/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class EpisodeViewControllerHeader: UIView {

    static let HeightCompactMax: CGFloat = 225
    static let HeightCompactMin: CGFloat = 60
    
    var height: CGFloat = 0.0 {
        didSet {
            heightConstraint.constant = height
            changeAlphaForHeight(constant: heightConstraint.constant)
        }
    }
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView?
    
    @IBOutlet weak var artWorkView: UIImageView?
    
    func changeAlphaForHeight(constant: CGFloat) {
        // 0 ~ 162 ~ 222.5
        // height constant : 60 ~ 222.5
        
        if (constant >= EpisodeViewControllerHeader.HeightCompactMax) {
            topView?.alpha = 1.0
        } else if (constant <= EpisodeViewControllerHeader.HeightCompactMin) {
            topView?.alpha = 0.0
        } else {
            
            topView?.alpha = CGFloat(constant - EpisodeViewControllerHeader.HeightCompactMin) / CGFloat(EpisodeViewControllerHeader.HeightCompactMax - EpisodeViewControllerHeader.HeightCompactMin)
        }
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
