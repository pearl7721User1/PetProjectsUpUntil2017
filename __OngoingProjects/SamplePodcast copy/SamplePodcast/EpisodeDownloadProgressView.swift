//
//  DownloadProgressView.swift
//  CoreGraphicsDrawingSample
//
//  Created by SeoGiwon on 4/28/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit




@IBDesignable
class EpisodeDownloadProgressView: UIView {
    
    fileprivate var startAction: (() -> ())?
    fileprivate var cancelAction: (() -> ())?
    
    var status: Episode.DownloadStatus = .downloadReady
    
    fileprivate lazy var progressDrawingView: ProgressDrawingView = {
    
        let theView = ProgressDrawingView()
        return theView
    }()
    
    
    convenience init() {
        
        let rect = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.init(frame:rect)
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.clear
        
        // add this view's tap gesture recognizer
        let gr = UITapGestureRecognizer(target: self, action: #selector(tapRecognizer(_:)))
        self.addGestureRecognizer(gr)
    }
    
    func tapRecognizer(_ gr: UITapGestureRecognizer) {
        
        if (status == .downloadReady) {
            
            if let startAction = startAction {
                startAction()
            }
        }
        else if (status == .downloading) {
            
            if let cancelAction = cancelAction {
                cancelAction()
            }
        }
    }
    
    func configureProperty(from model:Episode) {
        // set selectors
        startAction = model.startDownloadAction
        cancelAction = model.cancelDownloadAction

        // status
        updateDownloadStatus(newStatus: model.workingDownloadStatus)
        
        
        
        // delegate
        model.viewUpdateDelegate = self

        // progress update
        self.progressDrawingView.progress = model.workingProgress ?? 0.0
        
    }
    
    func notifyDownloadFinish() {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: DownloadCompleteNotificationName), object: self)
    }
}

extension EpisodeDownloadProgressView: DownloadViewUpdateProtocol {
    func updateProgress(value: CGFloat) {
        self.progressDrawingView.progress = value
    }
    
    func updateDownloadStatus(newStatus: Episode.DownloadStatus) {

        progressDrawingView.removeFromSuperview()
        
        switch newStatus {
        case .downloadReady:
            progressDrawingView.status = .ready
            self.addSubview(progressDrawingView)
            
        case .downloadWaiting:            
            progressDrawingView.status = .waiting
            self.addSubview(progressDrawingView)
            
        case .downloading:
            progressDrawingView.status = .progressing
            self.addSubview(progressDrawingView)
        case .finished:
            self.notifyDownloadFinish()
        }
        
        status = newStatus
    }

}
