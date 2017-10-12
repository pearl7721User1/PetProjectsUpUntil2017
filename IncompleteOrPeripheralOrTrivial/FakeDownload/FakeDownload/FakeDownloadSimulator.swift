//
//  File.swift
//  FakeDownload
//
//  Created by SeoGiwon on 4/20/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import Foundation

protocol FakeDownloadSimulatorProtocol: class {
    
    func simulator(_ simulator: FakeDownloadSimulator, didWriteData writtenAtMoment: Int, totalWritten totalAtMoment: Int, totalExpectedToWrite totalExptected: Int)
    
    func didFinishDownload(at simulator: FakeDownloadSimulator)
}

class FakeDownloadSimulator {
    
    weak var delegate: FakeDownloadSimulatorProtocol?
    private var timerBlock: () -> () = {}
    
    var downloadTimer: Timer?

    private var progress = 0 {
        
        didSet {
            if (progress >= 100) {
                downloadTimer?.invalidate()
                self.delegate?.didFinishDownload(at: self)
            }
        }
    }
    
    
    init() {
        timerBlock = {
            
            self.delegate?.simulator(self, didWriteData: 1, totalWritten: self.progress+1, totalExpectedToWrite: 100)
            self.progress += 1
        }
    }
    
    func timer() -> Timer {
        let theTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: {[unowned self](_) in
            
            self.timerBlock()
        })
        return theTimer
    }
    
    func download() {
        downloadTimer = timer()
        downloadTimer?.fire()
    }

    func cancel() {
        downloadTimer?.invalidate()
    }
    
}
