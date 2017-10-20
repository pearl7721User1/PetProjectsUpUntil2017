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

protocol DownloadViewUpdateProtocol {
    func updateProgress(value: CGFloat)
    func updateDownloadStatus(newStatus: Episode.DownloadStatus)
}

class DownloadController: NSObject {
    
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).coreDataStack.context
    }
    
    lazy var session: URLSession = {
        
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    
    var episodes = [Episode]()
    
    let podcastTitle: String
    
    init(podcastTitle: String) {
        self.podcastTitle = podcastTitle
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataModelChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
    }
    
    // MARK: - Core Data Model Change
    func handleDataModelChange(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
            
            // find 'episode's
            if let insertedEpisodes = inserts.filter({$0.entity.name == "Episode" }) as? [Episode] {
                
                // find 'episode's that belong to this podcast
                let validEpisodes = insertedEpisodes.filter({$0.podcast?.title == self.podcastTitle})
                
                // sort
                let sortedEpisodes = validEpisodes.sorted(by: { (left, right) -> Bool in
                    
                    if let leftPubDate = left.pubDate,
                        let rightPubDate = right.pubDate {
                        return leftPubDate.compare(rightPubDate as Date) == .orderedAscending
                    } else {
                        return true
                    }
                })
                
                // add it to the front
                for newEpisode in sortedEpisodes {
                    episodes.insert(newEpisode, at: 0)
                }
                
            }
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
            
            /*
            if let updatedEpisodes = updates.filter({$0.entity.name == "Episode" }) as? [Episode] {
                
                // find 'episode's that belong to this podcast
                let validEpisodes = updatedEpisodes.filter({$0.podcast?.title == self.podcastTitle})
                
                // iterate existing episodes and update the episodes
                
                
                
            }
            */
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
            
            /*
            if let deletedEpisodes = deletes.filter({$0.entity.name == "Episode" }) as? [Episode] {
                
                // find 'episode's that belong to this podcast
                let validEpisodes = deletedEpisodes.filter({$0.podcast?.title == self.podcastTitle})
                
                // iterate existing episodes and delete the episodes
                for existingEpisode in self.episodes {
                    
                    for newEpisode in validEpisodes {
                        
                        if existingEpisode === newEpisode {
                            // TODO: - 이거 정말 되냐?
                            
                            
                            
                        }
                    }
                }
                
 
            }
             */
            
        }
        
    }
    
    
    // MARK: - Create/Load/Save DownloadItems
    func loadEpisodes() {
        
        // fetch existing episode items in the Core Data
        var result: [Episode]?
        let fetchRequest: NSFetchRequest<Episode> = Episode.fetchRequest()
        
        // fetch only episodes of the passed podcast name
        fetchRequest.predicate = NSPredicate(format: "podcast.title = %@", podcastTitle)
        
        // write sort descriptors
        let sortDescriptor = NSSortDescriptor(key: "pubDate", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            result = try context.fetch(fetchRequest)
        }
        catch {
            result = nil
        }
        
        // set the download(able) items to this class's downloadItems property
        guard result != nil else { return }

        self.episodes = result!
        
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
            
            for index in 0..<self.episodes.count {
                
                let episode = self.episodes[index]
                episode.loadFromManagedObject()
                episode.session = self.session
                //                downloadItem.createTask()
            }
        }
    }
    
    
    
    func saveDownloads() {
        
        for episode in episodes {
            episode.writeManagedObjectProperty()
        }

    }
    
    
    /*
    // MARK: - Helpers
    func downloadedImage(index: Int, completion: ((UIImage?) -> ())?) {
        
        guard downloadItems[index].workingDownloadStatus == .finished,
            let urlStr = downloadItems[index].downloadLinkUrlStr else {
            
                if let completion = completion {
                    completion(nil)
                }
            return
        }
        
        // 8/5/2017
        GiwonWebImage.sharedInstance.image(from: urlStr) { (img: UIImage?) in
            if let completion = completion {
                completion(img)
            }
        }
        
    }
     */
    
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
                let episode = self.episode(taskIdentifier: Int16(task.taskIdentifier))
                episode?.resumeData = resumeData as NSData
            }
            
            completion(true)
        }
    }
    
    fileprivate func episode(taskIdentifier: Int16) -> Episode? {
        
        // see if there's any downloadItem that has the same taskIdentifier. If it is, it is the very downloadItem's resumeData that we need to update.
        let episode = self.episodes.filter({$0.downloadTaskIdentifier == taskIdentifier})
        
        // the filtered result cannot be multiple, because taskIdentifier is unique when it is created from the same URLSession
        return episodes.count > 0 ? episodes[0] : nil
    }
    

}

extension DownloadController: URLSessionDownloadDelegate, URLSessionDelegate, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("finished")
        
        /*
        
        if let originalURLString = downloadTask.originalRequest?.url?.absoluteString,
            let data = try? Data(contentsOf: location),
            let img = UIImage(data: data) {
            _ = GiwonWebImage.sharedInstance.save(image: img, urlStr:originalURLString)
        }
        else {
            // error handling
            
        }
 
         */
        
        // update view
        DispatchQueue.main.async {
            
            let episode = self.episode(taskIdentifier: Int16(downloadTask.taskIdentifier))
            episode?.finishDownload()
        }
    }
    
    func urlSession(_: URLSession, downloadTask: URLSessionDownloadTask, didWriteData: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        
        let written = ByteCountFormatter.string(fromByteCount: totalBytesWritten, countStyle: .binary)
        let total = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .binary)
        let progressValue = (Double(totalBytesWritten) / Double(totalBytesExpectedToWrite))
        
        print("taskID: \(downloadTask.taskIdentifier) written:\(written) total:\(total)")
        print("val:\(progressValue)")
        
        
        DispatchQueue.main.async {
            
            let episode = self.episode(taskIdentifier: Int16(downloadTask.taskIdentifier))
            
            if episode?.workingDownloadStatus != .downloading {
                episode?.workingDownloadStatus = .downloading
            }
            
            episode?.workingProgress = CGFloat(progressValue)
        }
    }
    
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
                    let episode = self.episode(taskIdentifier: Int16(task.taskIdentifier))
                    episode?.resumeData = nil
                    episode?.createTask()
                    episode?.resumeTask()
                }

            }
            
        }
    }

}
