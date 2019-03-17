//
//  PhotokitLockedView.swift
//  PhotokitMomentsTesting
//
//  Created by SeoGiwon on 12/28/16.
//  Copyright © 2016 SeoGiwon. All rights reserved.
//

import UIKit

// This view is designed to replace the other views if permission to Photos isn't allowed
class ViewForPermissionUnavailable: UIView {

    var lb = UILabel.init()
    var btn = UIButton.init(type: .roundedRect)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        lb.text = "Access to Photo gallery is locked."
        lb.textAlignment = .center
        self.addSubview(lb)
        
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant:0).isActive = true
        lb.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant:0).isActive = true
        
        self.addSubview(btn)
        btn.setTitle("Go to settings", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.centerXAnchor.constraint(equalTo: lb.centerXAnchor, constant:0).isActive = true
        btn.centerYAnchor.constraint(equalTo: lb.centerYAnchor, constant:50).isActive = true
        
        btn.addTarget(self, action: #selector(goToSettings(_:)), for: .touchUpInside)
    }
    
    func goToSettings(_ sender : UIButton) {
        
        UIApplication.shared.open(URL.init(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
