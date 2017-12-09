//
//  DashboardViewController.swift
//  SoundCloudProgrammingChallenge
//

import UIKit

// This View Controller manages the dashboard to show the number of trials and hits. The data is fed by the MemoryCellViewController object.
class DashboardViewController: UIViewController {

    // label to show how many trials have been made
    @IBOutlet weak var trialLabel: UILabel!
    
    // label to show how many hits have been made
    @IBOutlet weak var hitLabel: UILabel!
    
    var hit = 0 {
        didSet {
            hitLabel.text = "\(hit)"
        }
    }
    
    var trial = 0 {
        didSet {
            trialLabel.text = "\(trial)"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resetDashboard()
    }

    // reset figures to zeros
    func resetDashboard() {
        hit = 0
        trial = 0
    }
    
}


extension DashboardViewController: DashboardUpdateProtocol {
    
    // This delegate function defines what to do when the data is fed from the MemoryCellViewController object.
    func didTry(from memoryCellViewController: MemoryCellViewController, hit isHit: Bool) {
        
        // wait until flip animation ends and update the label
        let deadlineTime = DispatchTime.now() + .milliseconds(Int(flipAnimationDuration * 1000))
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            
            self.trial += 1
            if isHit { self.hit += 1 }

        }
        
        
    }
}
