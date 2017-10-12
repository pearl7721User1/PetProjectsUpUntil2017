//
//  DownloadItem+CoreDataClass.swift
//  DownloadControllerTest
//
//  Created by SeoGiwon on 30/07/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData


public class DownloadItem: NSManagedObject {
    
    // for updating the corresponding view for this download task model
    var viewUpdateDelegate: DownloadViewUpdateProtocol?
    
    
    // MARK: - Code level properties
    /*
         Only some types of properties archive in the Core Data. URLSessionDownloadTask, URLSession are not among them. Also, you cannot use didSet on NSManagedObject properties. That's why I decided to seprate some properties from them so that I can make good use in the code level. Because of this, binding Core Data properties and code level properties when writing, reading is necessary.
     */
    
    var session: URLSession?
    var downloadTask: URLSessionDownloadTask?

    var workingProgress: CGFloat = 0 {
        didSet {
            
            viewUpdateDelegate?.updateProgress(value: workingProgress)
        }
    }
    
    var workingDownloadStatus = DownloadStatus.downloadReady {
        didSet {
            viewUpdateDelegate?.updateDownloadStatus(newStatus: workingDownloadStatus)
        }
    }
    
    // MARK: - Binding to the View
    // four possible download states. Some are triggered by the URLSession delegate function, others are triggered by the view
    enum DownloadStatus: Int {
        case downloadReady, downloadWaiting, downloading, finished
    }
    
    // closure to be bound as the view's button selector
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
    
    // closure to be bound as the view's button selector
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
        
        /*
          There are two ways to create a download task. One is to taking a url as a parameter, the other is to taking the resumeData. resumeData is produced when the download task is canceled before it's finished. Since the resumeData is persisting in the Core Data in this app, download task can be resumed.
         */
        if let resumeData = resumeData {
            downloadTask = session?.downloadTask(withResumeData: resumeData as Data)
        } else {
            
            if let urlStr = downloadLinkUrlStr,
                let url = URL(string: urlStr) {
                downloadTask = session?.downloadTask(with: url)
            }
        }
        
        if let downloadTask = downloadTask {
            self.downloadTaskIdentifier = Int16(downloadTask.taskIdentifier)
        }
    }
    
    // MARK: - Initializer
    convenience init(request: DownloadRequest) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
        
        self.title = request.title
        self.downloadLinkUrlStr = request.url.absoluteString
        
        downloadTaskIdentifier = -1
    }
    
    // MARK: - Functions to wire up core data properties and the responding code level properties
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
