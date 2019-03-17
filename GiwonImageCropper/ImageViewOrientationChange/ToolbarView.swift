//
//  ToolbarView.swift
//  ImageViewOrientationChange
//
//  Created by SeoGiwon on 3/2/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

protocol ToolbarViewDelegate {
    
    func cropBtnTapped()
}

class ToolbarView: UIView {
    
    var cropBtn: UIButton!
    var delegate: ToolbarViewDelegate?
    fileprivate var portraitConstraints = [NSLayoutConstraint]()
    fileprivate var landscapeConstraints = [NSLayoutConstraint]()

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        setup()
        setupConstraints()
    }
    
    
    func setup() {
        
        // configure for self view's background color
        self.backgroundColor = UIColor.black
        
        // assign cropBtn
        cropBtn = UIButton(type: .roundedRect)
        cropBtn.addTarget(self, action: #selector(cropBtnTapped(_:)), for: .touchUpInside)
        cropBtn.setTitle("Crop", for: .normal)
        cropBtn.setTitleColor(UIColor.white, for: .normal)
        
        // add cropBtn to view hierarchy
        self.addSubview(cropBtn)
    }
    
    func setupConstraints() {
        
        // set constraints for subviews
        cropBtn.translatesAutoresizingMaskIntoConstraints = false
        
        portraitConstraints.append(cropBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15))
        portraitConstraints.append(cropBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor))
        
        landscapeConstraints.append(cropBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 15))
        landscapeConstraints.append(cropBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        switch UIDevice.current.orientation {
        case .portrait:
            cropBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            NSLayoutConstraint.activate(portraitConstraints)
            NSLayoutConstraint.deactivate(landscapeConstraints)
            
        default:
            cropBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            NSLayoutConstraint.activate(landscapeConstraints)
            NSLayoutConstraint.deactivate(portraitConstraints)
        }
    }
 
    func cropBtnTapped(_ sender: UIButton) {
        
        delegate?.cropBtnTapped()
    }
    
}
