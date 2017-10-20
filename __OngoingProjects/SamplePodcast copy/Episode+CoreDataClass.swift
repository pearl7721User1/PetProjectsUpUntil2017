//
//  Episode+CoreDataClass.swift
//  SamplePodcast
//
//  Created by SeoGiwon on 22/09/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//
//

import UIKit
import CoreData


public class Episode: NSManagedObject {

    var viewUpdateDelegate: DownloadViewUpdateProtocol?
    
    // MARK: - Properties separated from Core Data's
    var session: URLSession?
    var downloadTask: URLSessionDownloadTask?
    
    var workingProgress: CGFloat = 0 {
        didSet {
            
            viewUpdateDelegate?.updateProgress(value: workingProgress ?? 0.0)
        }
    }
    
    var workingDownloadStatus = DownloadStatus.downloadReady {
        didSet {
            viewUpdateDelegate?.updateDownloadStatus(newStatus: workingDownloadStatus)
        }
    }
    
    // MARK: - Download Status
    enum DownloadStatus: Int {
        case downloadReady, downloadWaiting, downloading, finished
    }
    
    lazy var startDownloadAction: () -> () = {
        
        let oldStatus = self.workingDownloadStatus
        
        switch oldStatus {
        case .downloadReady:
            self.workingDownloadStatus = .downloadWaiting
            self.createTask()
            self.resumeTask()
        default:
            break
        }
    }
    
    lazy var cancelDownloadAction: () -> () = {
        self.cancelTask()
        self.workingDownloadStatus = DownloadStatus.downloadReady
    }
    
    
    func finishDownload() {
        workingDownloadStatus = DownloadStatus.finished
    }
    
    // MARK: - Download Task functions
    func resumeTask() {
        downloadTask?.resume()
    }
    
    func cancelTask() {
        downloadTask?.cancel(byProducingResumeData: { (data: Data?) in
            self.resumeData = data as NSData?
            self.writeManagedObjectProperty()
        })
    }
    
    func createTask() {
        
        if let resumeData = resumeData {
            downloadTask = session?.downloadTask(withResumeData: resumeData as Data)
        } else {
            
            if let urlStr = audioLink,
                let url = URL(string: urlStr) {
                downloadTask = session?.downloadTask(with: url)
            }
        }
        
        if let downloadTask = downloadTask {
            self.downloadTaskIdentifier = Int16(downloadTask.taskIdentifier)
        }
    }
    
    // MARK: - Functions to wire up core data properties and the reponsing class properties
    func writeManagedObjectProperty() {
        
        // write nsmanged object properties
        progress = Float(workingProgress)
        
        if [DownloadStatus.downloading].contains(workingDownloadStatus) {
            downloadStatus = Int16(DownloadStatus.downloadReady.rawValue)//.downloadReady.rawV
        } else {
            downloadStatus = Int16(workingDownloadStatus.rawValue)
        }
        
        print("downloadIdentifier: \(downloadTaskIdentifier)")
        
    }
    
    func loadFromManagedObject() {
        
        // load properties from nsmanaged object
        workingProgress = CGFloat(progress)
        
        print("downloadIdentifier: \(downloadTaskIdentifier)")
        
        if let downloadStatus = DownloadStatus.init(rawValue: Int(downloadStatus)) {
            workingDownloadStatus = downloadStatus
        }
        
    }
}
