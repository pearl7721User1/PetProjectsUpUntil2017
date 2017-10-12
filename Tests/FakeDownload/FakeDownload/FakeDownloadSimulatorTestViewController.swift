//
//  ViewController.swift
//  FakeDownload
//
//  Created by SeoGiwon on 4/20/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class FakeDownloadSimulatorTestViewController: UIViewController {

    lazy var downloadSimulator: FakeDownloadSimulator = {
       
        let simulator = FakeDownloadSimulator()
        simulator.delegate = self
        
        return simulator
    }()
    
    private var timerBlock: () -> () = {}
    @IBOutlet weak var myProgressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnTapped(_ sender: UIButton) {
        
        if sender.tag == 1 {
            // download
            downloadSimulator.download()
        }
        else if sender.tag == 2 {
            // pause
        //    downloadSimulator.pause()
        }
        else if sender.tag == 3 {
            // cancel
            downloadSimulator.cancel()
        }
        else if sender.tag == 4 {
            // resume
        //    downloadSimulator.resume()
        }
    }

    
}


extension FakeDownloadSimulatorTestViewController: FakeDownloadSimulatorProtocol {
    
    func simulator(_ simulator: FakeDownloadSimulator, didWriteData writtenAtMoment: Int, totalWritten totalAtMoment: Int, totalExpectedToWrite totalExptected: Int) {
        
        print("written:\(writtenAtMoment), totalWritten:\(totalAtMoment), totalExpectedToTwrite:\(totalExptected)")
        
        myProgressView.progress = Float(totalAtMoment) / Float(totalExptected)
    }
    
    func didFinishDownload(at simulator: FakeDownloadSimulator) {
        print("finishDownloading")
    }
}
