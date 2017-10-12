//
//  ViewController.swift
//  CoreGraphicsBlending
//
//  Created by SeoGiwon on 17/06/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let myView = MyView()
    var bgViewColor = UIColor.white {
        didSet {
            myView.backgroundColor = bgViewColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.view.addSubview(myView)
        myView.backgroundColor = bgViewColor
        myView.center = self.view.center
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MySegue" {
            if let vc = segue.destination as? ColorSliderViewController {
                
                vc.delegate = self
                
                var rPtr:CGFloat = 0.0
                var gPtr:CGFloat = 0.0
                var bPtr:CGFloat = 0.0
                
                if bgViewColor.getRed(&rPtr, green: &gPtr, blue: &bPtr, alpha: nil) {
                    
                    vc.rValue = Float(rPtr)
                    vc.gValue = Float(gPtr)
                    vc.bValue = Float(bPtr)
                    
                } else {
                    print("bgViewColor.getRed error")
                }
                
            }
        }
    }

    
}

extension ViewController: ViewColorUpdate {
    func updated(with R:CGFloat, G:CGFloat, B:CGFloat, at:ViewType) {
        
        myView.backgroundColor = UIColor(red: R, green: G, blue: B, alpha: 1.0)
        
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return blendModes.count
    }
}

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return blendModes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let rowInt32 = Int32(row)
        
        if let blendMode = CGBlendMode(rawValue: Int32(row)) {
            myView.blendMode = blendMode
        }
        
        
    }
}

let blendModes = ["Normal", "Multiply", "Screen",
"Overlay",
"Darken",
"Lighten",
"ColorDodge",
"ColorBurn",
"SoftLight",
"HardLight",
"Difference",
"Exclusion",
"Hue",
"Saturation",
"Color",
"Luminosity",
// Porter-Duff Blend Modes.
"Clear",
"Copy",
"SourceIn",
"SourceOut",
"SourceAtop",
"DestinationOver",
"DestinationIn",
"DestinationOut",
"DestinationAtop",
"XOR",
"PlusDarker",
"PlusLighter"]
