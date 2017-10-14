//
//  ViewController.swift
//  ConstraintsShift
//
//  Created by SeoGiwon on 11/29/16.
//  Copyright © 2016 SeoGiwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var view1: UIView?
    var view2: UIView!

    
    var portraitConstraints = [NSLayoutConstraint]()
    var landscapeConstraints = [NSLayoutConstraint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         // Do any additional setup after loading the view, typically from a nib.
         view1 = UIView.init()
         view1?.backgroundColor = UIColor.blue
         self.view.addSubview(view1!)
         
         view2 = UIView.init()
         view2?.backgroundColor = UIColor.green
         view1?.addSubview(view2!)
         
         view1?.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 375, height: 60))
         view1?.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin]
         */
        
        view1 = UIView.init()
        view1?.backgroundColor = UIColor.blue
        view1?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view1!)
        
        
        view2 = UIView.init()
        view2.backgroundColor = UIColor.green
        view2.frame = CGRect.init(x: 10, y: 10, width: 30, height: 30)
        view1?.addSubview(view2)
        
        view2.autoresizingMask = [.flexibleWidth]
        
        
        calculateConstraints()
        applyAutoLayout()
    }
    
    func applyAutoLayout() {
        if self.traitCollection.verticalSizeClass == .regular {
            // iphone6 portrait
            
            NSLayoutConstraint.deactivate(landscapeConstraints)
            NSLayoutConstraint.activate(portraitConstraints)
        }
        else {
            // iphone6 landscape
            
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.activate(landscapeConstraints)
        }
    }
    
    func calculateConstraints()
    {
        portraitConstraints.append((view1?.topAnchor.constraint(equalTo: self.view.topAnchor))!)
        portraitConstraints.append((view1?.leftAnchor.constraint(equalTo: self.view.leftAnchor))!)
        portraitConstraints.append((view1?.rightAnchor.constraint(equalTo: self.view.rightAnchor))!)
        portraitConstraints.append((view1?.heightAnchor.constraint(equalToConstant: 60))!)
        
        landscapeConstraints.append((view1?.topAnchor.constraint(equalTo: self.view.topAnchor))!)
        landscapeConstraints.append((view1?.leftAnchor.constraint(equalTo: self.view.leftAnchor))!)
        landscapeConstraints.append((view1?.rightAnchor.constraint(equalTo: self.view.rightAnchor))!)
        landscapeConstraints.append((view1?.heightAnchor.constraint(equalToConstant: 30))!)
    }
    
    override func viewWillLayoutSubviews() {
        
        print(view1?.frame)
        
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
    {
        print("horizontal:\(self.traitCollection.horizontalSizeClass.rawValue)")
        print("vertical:\(self.traitCollection.verticalSizeClass.rawValue)")
        applyAutoLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     - (void) traitCollectionDidChange: (UITraitCollection *) previousTraitCollection {
     [super traitCollectionDidChange: previousTraitCollection];
     if ((self.traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass)
     || self.traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass)) {
     // your custom implementation here
     }
     }
     */
}

