//
//  ColorSliderViewController.swift
//  CoreGraphicsBlending
//
//  Created by SeoGiwon on 17/06/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

protocol ViewColorUpdate {
    func updated(with R:CGFloat, G:CGFloat, B:CGFloat, at:ViewType)
}

enum ViewType {
    case BG, Contents
}

class ColorSliderViewController: UIViewController {

    @IBOutlet weak var bSlider: UISlider!
    @IBOutlet weak var gSlider: UISlider!
    @IBOutlet weak var rSlider: UISlider!
    
    var rValue: Float = 0.0
    var gValue: Float = 0.0
    var bValue: Float = 0.0
    
    var delegate: ViewColorUpdate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        rSlider.value = rValue
        gSlider.value = gValue
        bSlider.value = bValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        var r: CGFloat = CGFloat(rSlider.value)
        var g: CGFloat = CGFloat(gSlider.value)
        var b: CGFloat = CGFloat(bSlider.value)
        
        if (sender == rSlider) {
            sender.value = Float(r)
        }
        
        if (sender == gSlider) {
            sender.value = Float(g)
        }
        
        if (sender == bSlider) {
            sender.value = Float(b)
        }
        
        delegate?.updated(with: r, G: g, B: b, at: .BG)
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
