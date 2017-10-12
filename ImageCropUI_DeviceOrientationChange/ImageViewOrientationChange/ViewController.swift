//
//  ViewController.swift
//  ImageViewOrientationChange
//
//  Created by SeoGiwon on 1/21/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // CropView is made of layers of different views - an image view and a crop rect view. This view takes care of cropping of the designated rect; cropping is signaled by the button on the toolbarView.
    var cropView = CropView()
    
    // ToolbarView displays the button to interact with the crop view.
    var toolbarView = ToolbarView()
    
    // Storyboard provides convenient options to set constraints. But, I wanted to customize it further so that the layout looks much better when device orientation changes like what you see in Photos app. And, it is impossible with setting constraints in the Storyboard.
    fileprivate var portraitConstraints = [NSLayoutConstraint]()
    fileprivate var landscapeLeftConstraints = [NSLayoutConstraint]()
    fileprivate var landscapeRightConstraints = [NSLayoutConstraint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // install cropView
        cropView.delegate = self
        self.view.addSubview(cropView)
        
        // install toolbarView
        toolbarView.delegate = self
        self.view.addSubview(toolbarView)
        
        // set constraints
        setupConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    func setupConstraints() {
        // create constrain objects and append them to different arrays so that each one can be switched on/off in response to device orientation changes
        
        cropView.translatesAutoresizingMaskIntoConstraints = false
        toolbarView.translatesAutoresizingMaskIntoConstraints = false
        
        portraitConstraints.append(cropView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30))
        portraitConstraints.append(cropView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20))
        portraitConstraints.append(cropView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20))
        portraitConstraints.append(cropView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -200))
        
        portraitConstraints.append(toolbarView.heightAnchor.constraint(equalToConstant: 50))
        portraitConstraints.append(toolbarView.leftAnchor.constraint(equalTo: self.view.leftAnchor))
        portraitConstraints.append(toolbarView.rightAnchor.constraint(equalTo: self.view.rightAnchor))
        portraitConstraints.append(toolbarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor))
        
        landscapeLeftConstraints.append(cropView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20))
        landscapeLeftConstraints.append(cropView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30))
        landscapeLeftConstraints.append(cropView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -200))
        landscapeLeftConstraints.append(cropView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20))
        
        
        landscapeLeftConstraints.append(toolbarView.widthAnchor.constraint(equalToConstant: 50))
        landscapeLeftConstraints.append(toolbarView.topAnchor.constraint(equalTo: self.view.topAnchor))
        landscapeLeftConstraints.append(toolbarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor))
        landscapeLeftConstraints.append(toolbarView.rightAnchor.constraint(equalTo: self.view.rightAnchor))
        
        
        landscapeRightConstraints.append(cropView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20))
        landscapeRightConstraints.append(cropView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 200))
        landscapeRightConstraints.append(cropView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30))
        landscapeRightConstraints.append(cropView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20))
        
        
        landscapeRightConstraints.append(toolbarView.topAnchor.constraint(equalTo: self.view.topAnchor))
        landscapeRightConstraints.append(toolbarView.leftAnchor.constraint(equalTo: self.view.leftAnchor))
        landscapeRightConstraints.append(toolbarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor))
        landscapeRightConstraints.append(toolbarView.widthAnchor.constraint(equalToConstant: 50))
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // switch on/off constraints
        
        super.traitCollectionDidChange(previousTraitCollection)
        
        switch UIDevice.current.orientation {
        case .portrait:
            NSLayoutConstraint.activate(portraitConstraints)
            NSLayoutConstraint.deactivate(landscapeLeftConstraints)
            NSLayoutConstraint.deactivate(landscapeRightConstraints)
            
        case .landscapeLeft:
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.activate(landscapeLeftConstraints)
            NSLayoutConstraint.deactivate(landscapeRightConstraints)
            
        case .landscapeRight:
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.deactivate(landscapeLeftConstraints)
            NSLayoutConstraint.activate(landscapeRightConstraints)
            
        default:
            break
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override var prefersStatusBarHidden: Bool {
        return true
    }  
}

extension ViewController: CropViewDelegate {
    // this protocol defines interaction between CropView and this view controller
    
    func cropDidOccur(to toImg: UIImage?, from fromImg: UIImage?, at cropOrigin: CGPoint?) {
        // this func is called from the CropView to deliver the cropped image to this view controller
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let detailVC = storyboard.instantiateViewController(withIdentifier:"detailVC") as? CroppedImgPresentationViewController else { fatalError() }
        
        
        detailVC.img = toImg
        detailVC.originalImgSize = fromImg?.size
        detailVC.croppedImgOrigin = cropOrigin
        
        self.present(detailVC, animated: true, completion: nil)
    }
}

extension ViewController: ToolbarViewDelegate {
    // this protocol defines interaction between ToolbarView and this view controller
    
    func cropBtnTapped() {
        // this func is called from ToolbarView, and it's triggered when the button of ToolbarView is tapped
        
        self.cropView.crop()
    }
}
