//
//  DownloadStatusView.swift
//  CoreGraphicsDrawingSample
//
//  Created by SeoGiwon on 4/28/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class DownloadStatusView: UIView {

    enum DownloadStatus {
        case downloading, readyToDownload, completed
    }
    
    var downloadStatus = DownloadStatus.readyToDownload {
        didSet {
            
            readyForDownloadView.removeFromSuperview()
            downloadingView.removeFromSuperview()
            completedView.removeFromSuperview()
            
            switch downloadStatus {
            case .readyToDownload:
                self.addSubview(readyForDownloadView)
            case .downloading:
                self.addSubview(downloadingView)
            case .completed:
                self.addSubview(completedView)
            }
        }
    }
    
    let readyForDownloadView: ReadyForDownloadView = {
        
        let readyForDownloadImage = ReadyForDownloadView.image()
        let theView = ReadyForDownloadView()
        theView.layer.contents = readyForDownloadImage.cgImage
    
        return theView
    }()
    
    let downloadingView: DownloadingView = {
        
        let theView = DownloadingView()
        return theView
    }()
    
    let completedView: UIView = {
       
        let theView = UIView()
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
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.backgroundColor = UIColor.clear
        downloadStatus = DownloadStatus.readyToDownload
        self.addSubview(readyForDownloadView)
        
        // add this view's tap gesture recognizer
        let gr = UITapGestureRecognizer(target: self, action: #selector(tapRecognizer(_:)))
        self.addGestureRecognizer(gr)
    }
    
    func tapRecognizer(_ gr: UITapGestureRecognizer) {
        
        if (downloadStatus == .readyToDownload) { downloadStatus = .downloading }
        else if (downloadStatus == .downloading) { downloadStatus = .readyToDownload }
        
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
