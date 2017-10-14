//
//  ViewController.swift
//  FlexibleWidthTesting
//
//  Created by SeoGiwon on 11/29/16.
//  Copyright © 2016 SeoGiwon. All rights reserved.
//



import UIKit


class ViewController: UIViewController {

    var view1: UIView!
    var view2: UIView?
    
    
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

        // create a view in code
        view1 = UIView.init()
        view1.backgroundColor = UIColor.blue
        
        // add the view to the superview
        // adding must be preceded before setting Constraints
        // otherwise, exception will occur
        self.view.addSubview(view1)
        
        // by default, the value is set to 'true'
        // If this flag isn't set to 'false', Constraints won't fly
        view1.translatesAutoresizingMaskIntoConstraints = false
        
        // set Constraints for the view
        view1.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        view1.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        view1.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        view1.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }

    override func viewWillLayoutSubviews() {
        
        print(view1?.frame)
        
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
    {
        print("horizontal:\(self.traitCollection.horizontalSizeClass.rawValue)")
        print("vertical:\(self.traitCollection.verticalSizeClass.rawValue)")
        
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

