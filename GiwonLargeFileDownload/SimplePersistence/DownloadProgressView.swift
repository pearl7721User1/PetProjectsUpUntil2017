//
//  DownloadProgressView.swift
//  CoreGraphicsDrawingSample
//
//  Created by SeoGiwon on 4/28/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit


protocol DownloadViewUpdateProtocol {
    func updateProgress(value: CGFloat)
    func updateDownloadStatus(newStatus: DownloadItem.DownloadStatus)
}

@IBDesignable
class DownloadProgressView: UIView {
    
    // MARK: - Binding to the Download Task Model
    // selector actions for binding to the download task model
    fileprivate var startAction: (() -> ())?
    fileprivate var cancelAction: (() -> ())?
    
    // the download task model's state
    var status: DownloadItem.DownloadStatus = .downloadReady
    
    // binding this view to the corresponding download task model
    func configureProperty(from model:DownloadItem) {
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
    
    
    // MARK: - View Creation/Updates
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
    
    
    // MARK: - Notification
    // notifies the other views that the download task is finished
    func notifyDownloadFinish() {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: DownloadCompleteNotificationName), object: self)
    }
}

extension DownloadProgressView: DownloadViewUpdateProtocol {
    func updateProgress(value: CGFloat) {
        self.progressDrawingView.progress = value
    }
    
    // update the view depending on the download task model state
    func updateDownloadStatus(newStatus: DownloadItem.DownloadStatus) {

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
            
            // notifies the other views that the download task is finished
            self.notifyDownloadFinish()
        }
        
        status = newStatus
    }

}
