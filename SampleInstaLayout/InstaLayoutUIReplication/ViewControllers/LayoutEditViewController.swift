//
//  LayoutEditViewController.swift
//  ReplaceScrollViewTest
//
//  Created by SeoGiwon on 13/10/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class LayoutEditViewController: UIViewController {

    var photoSplitView: LayoutEditingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(photoSplitView)
        setupConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        photoSplitView.createSnapShot()
    }
    
    func setupConstraints() {
        photoSplitView.translatesAutoresizingMaskIntoConstraints = false
        
        photoSplitView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        photoSplitView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        photoSplitView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64).isActive = true
        photoSplitView.heightAnchor.constraint(equalToConstant: photoSplitView.defaultViewHeight).isActive = true
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
