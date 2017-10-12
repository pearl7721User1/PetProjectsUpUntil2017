//
//  abc.swift
//  DownloadControllerTest
//
//  Created by SeoGiwon on 13/07/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData

let DownloadCompleteNotificationName = "DownloadCanContinue"

class DownloadController: NSObject {
    
    
    private (set) static var shared: DownloadController = DownloadController()
    
    // session will last beyond the app launch, termination as long as it is configured as a background session with the same identifier. That way, downloads will continue even if the app goes to the background, and the tasks are restorable even if the app is terminated eventually.
    lazy var session: URLSession = {
        
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    // list of download tasks, or more precisely, resumeData is preserved using Core Data persistence
    var downloadItems = [DownloadItem]()

    // temporary function to create a random download tasks for the app
    static func randomDownloadRequests() -> [DownloadRequest] {
        
        let urlStrs:[String] = [
            "https://photojournal.jpl.nasa.gov/tiff/PIA14832.tif",
            "https://photojournal.jpl.nasa.gov/tiff/PIA21776.tif",
            "https://photojournal.jpl.nasa.gov/tiff/PIA15482.tif",
            "https://photojournal.jpl.nasa.gov/tiff/PIA12832.tif",
            "https://photojournal.jpl.nasa.gov/tiff/PIA14871.tif",
            "https://upload.wikimedia.org/wikipedia/commons/6/6e/1_pano_machu_picchu_guard_house_river_2014.jpg",
            "https://photojournal.jpl.nasa.gov/tiff/PIA15417.tif",
            "https://photojournal.jpl.nasa.gov/tiff/PIA17800.tif",
            "https://photojournal.jpl.nasa.gov/tiff/PIA18033.tif",
            "https://www.petmd.com/sites/default/files/what-does-it-mean-when-cat-wags-tail.jpg"
        ]
        
        var urls = [URL]()
        
        for urlStr in urlStrs {
            if let url = URL(string:urlStr) {
                urls.append(url)
            }
            
        }
        
        let titles:[String] = [
            "Curiosity Approaching Mars, Artist's Concept",
            "Jupiter Storm of the High North",
            "Mapping the Infrared Universe: The Entire WISE Sky -- Rectangular Format",
            "Our Neighbor Andromeda",
            "All That Remains of Exploded Star",
            "Machu picchu",
            "CW leo",
            "OCO-2 in Space",
            "Earth",
            "Test Cat Photo"
        ]
        
        let sortedTitles = titles.sorted(by: {$0 < $1})
        
        if urls.count != sortedTitles.count {
            fatalError()
        }
        
        var downloadRequests = [DownloadRequest]()
        
        for index in 0..<urls.count {
            let url = urls[index]
            let request = DownloadRequest(url: url, title: sortedTitles[index])
            downloadRequests.append(request)
        }
        
        return downloadRequests
    }
    
    
    // MARK: - Create/Load/Save DownloadItems
    
    // creating download tasks. This function is executed on the very first launch only, just to create random download tasks for a starter
    func createDownloadItems(requests: [DownloadRequest]) {
        
        for index in 0..<requests.count {
            
            // newly create downloadable items
            let request = requests[index]
            let downloadItem = DownloadItem(request: request)
            
            // set sessions
            downloadItem.session = session
            
            // create a download task without resuming
            downloadItems.append(downloadItem)
        }
        
    }
    
    // load download tasks from Core Data
    func loadTasks() {
        
        // fetch existing download(able) items in the Core Data
        var result: [DownloadItem]?
        let fetchRequest: NSFetchRequest<DownloadItem> = DownloadItem.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            result = try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(fetchRequest)
        }
        catch {
            result = nil
        }

        // set the download(able) items to this class's downloadItems property
        guard let downloadItems = result else { return }
        self.downloadItems = downloadItems
        
        /*
         Note:
         
         DownloadLinkUrlStr and/or ResumeData is brought to life from Core Data at this point.
         If resumeData exists, we take resumeData as a parameter and re-create a download task.
         Otherwise, a download task is re-created by taking downloadLinkUrlStr as a parameter.
         
         About pulling resume data:
         There's a case where resumeData is not the latest downloads or doesn't exist at all. Such cases occur when the app is terminated forcibly while downloading. But, the resumeData is not lost. URL background session is saving it temporarily. Our job is to reading the single or multiple resumeData from the URLSession, and update the resumeData that each downloadItem owns.
         
         How do you tell which downloadItem to update?
         By comparing TaskIdentifier.
         */
        
        pullResumeDataIfErrorOccurred { (finished) -> (Void) in
            
            for index in 0..<self.downloadItems.count {
                
                let downloadItem = self.downloadItems[index]
                downloadItem.loadFromManagedObject()
                downloadItem.session = self.session
            }
        }
    }
    
    func saveTasks() {
        
        for downloadItem in downloadItems {
            downloadItem.writeManagedObjectProperty()
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    
    
    // MARK: - Helpers
    // function to gets the finished download. In this app, the download is always an image.
    func downloadedImage(index: Int, completion: ((UIImage?) -> ())?) {
        
        guard downloadItems[index].workingDownloadStatus == .finished,
            let urlStr = downloadItems[index].downloadLinkUrlStr else {
            
                if let completion = completion {
                    completion(nil)
                }
            return
        }
        
        GiwonWebImage.sharedInstance.image(from: urlStr) { (img: UIImage?) in
            if let completion = completion {
                completion(img)
            }
        }
        
    }
    
    // retrieve the cached resumeData from the URLSession if any, and update it
    private func pullResumeDataIfErrorOccurred(completion: @escaping (_ finished: Bool) -> (Void)) {
        
        let session = self.session
        
        session.getAllTasks { (tasks: [URLSessionTask]) in
            
            // see if there's any cached resumeData
            for index in 0..<tasks.count {
                guard let task = tasks[index] as? URLSessionDownloadTask,
                    let error = task.error as NSError?,
                    let resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData] as? Data else { continue }
                
                // update ResumeData
                let downloadItem = self.downloadItem(taskIdentifier: Int16(task.taskIdentifier))
                downloadItem?.resumeData = resumeData as NSData
            }
            
            completion(true)
        }
    }
    
    fileprivate func downloadItem(taskIdentifier: Int16) -> DownloadItem? {
        
        // see if there's any downloadItem that has the same taskIdentifier. If it is, it is the very downloadItem's resumeData that we need to update.
        let downloads = self.downloadItems.filter({$0.downloadTaskIdentifier == taskIdentifier})
        
        // the filtered result cannot be multiple, because taskIdentifier is unique when it is created from the same URLSession
        return downloads.count > 0 ? downloads[0] : nil
    }
    

}

extension DownloadController: URLSessionDownloadDelegate, URLSessionDelegate, URLSessionTaskDelegate {
    
    // this function is called when the download task is complete
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("finished")
        
        // save the downloaded image locally
        if let originalURLString = downloadTask.originalRequest?.url?.absoluteString,
            let data = try? Data(contentsOf: location),
            let img = UIImage(data: data) {
            _ = GiwonWebImage.sharedInstance.save(image: img, urlStr:originalURLString)
        }
        else {
            // error handling
            
        }
        
        // have the download task model to notify the view
        DispatchQueue.main.async {
            
            let downloadItem = self.downloadItem(taskIdentifier: Int16(downloadTask.taskIdentifier))
            downloadItem?.finishDownload()
        }
    }
    
    // this function is called each time the download progress is made
    func urlSession(_: URLSession, downloadTask: URLSessionDownloadTask, didWriteData: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        // transition the download task model's state as 'downloading', and updates the download progress
        let written = ByteCountFormatter.string(fromByteCount: totalBytesWritten, countStyle: .binary)
        let total = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .binary)
        let progressValue = (Double(totalBytesWritten) / Double(totalBytesExpectedToWrite))
        
        print("taskID: \(downloadTask.taskIdentifier) written:\(written) total:\(total)")
        print("val:\(progressValue)")
        
        
        DispatchQueue.main.async {
            
            let downloadItem = self.downloadItem(taskIdentifier: Int16(downloadTask.taskIdentifier))
            
            if downloadItem?.workingDownloadStatus != .downloading {
                downloadItem?.workingDownloadStatus = .downloading
            }
            
            downloadItem?.workingProgress = CGFloat(progressValue)
        }
    }
    
    // this function is called when the download task is complete when running in the background
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
        print("finishEvents")
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                DispatchQueue.main.async(execute: {
                    completionHandler()
                })
            }
        }
    }
    
    // TODO: - If an error occurs and fails to proceed the download, there's gotta be a way to find the task in the DownloadItems to delete the resumeData, so that a new download try can start newly. -3003 error might occur for iOS 10.0, 10.1. This error means that a background session cannot create a task with resumeData. It is a known bug.
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        DispatchQueue.main.async {
            
            if let error = error as NSError? {
                
                print("errorCode: \(error.code), domain: \(error.domain)")

                if error.code == -3003 {
                    // update ResumeData
                    let downloadItem = self.downloadItem(taskIdentifier: Int16(task.taskIdentifier))
                    downloadItem?.resumeData = nil
                    downloadItem?.createTask()
                    downloadItem?.resumeTask()
                }

            }
            
        }
    }

}
