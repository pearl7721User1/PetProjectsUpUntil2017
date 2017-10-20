//
//  File.swift
//  SamplePodcast
//
//  Created by SeoGiwon on 19/08/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData

// MARK: - Core Data stack

class CoreDataStack {
    
    var context:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "SamplePodcast")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func newlyAddPodcastFromRSSList(id: Int, completion: @escaping (_ finished: Bool) -> Void) {
        
        
        // read the link from AvailableRSSFeeds
        guard let rssFeed = AvailableRSSFeed.rssFeed(id: id),
            let feedLink = rssFeed.link else {
            completion(false)
            return
        }
        
        PodcastParser.shared.podcast(rssFeedURL: feedLink) { (podcastJSON: [String : Any]?) in
            
            
            // parse podcast json
            guard let podcastJSON = podcastJSON,
                let podcastTitle = podcastJSON["title"] as? String,
                let podcastImageData = podcastJSON["imageData"] as? NSData,
                let episodesJSON = podcastJSON["episodes"] as? [[String: Any]] else {
                    completion(false)
                    return
            }
            
            // fetch podcast
            let newPodcast = Podcast(context: self.context)
            
            // podcast title
            newPodcast.title = podcastTitle
            
            // podcast image
            newPodcast.image = podcastImageData
            
            // podcast rss feed
            newPodcast.rssFeedLink = feedLink
            
            
            for episodeJSON in episodesJSON {
                
                if let guid = episodeJSON["guid"] as? String,
                    let title = episodeJSON["title"] as? String,
                    let episodeDescription = episodeJSON["episodeDescription"] as? String,
                    let pubDate = episodeJSON["pubDate"] as? NSDate,
                    let audioLink = episodeJSON["audioLink"] as? String,
                    let fileSize = episodeJSON["fileSize"] as? String {
                    
                    // newly create
                    let newEpisode = Episode(context: self.context)
                    
                    // download identifier
                    newEpisode.downloadTaskIdentifier = -1
                    
                    // guid
                    newEpisode.guid = guid
                    
                    // title
                    newEpisode.title = title
                    
                    // description
                    newEpisode.episodeDescription = episodeDescription
                    
                    // pubdate
                    newEpisode.pubDate = pubDate
                    
                    // audio link
                    newEpisode.audioLink = audioLink
                    
                    // file size
                    newEpisode.fileSize = fileSize
                    
                    // add to the podcast
                    newPodcast.addToEpisodes(newEpisode)
                    
                }
            }
                    
            // end of for statement
            
            print("reached the end of for statement")
            
            completion(true)
            
        }
        
    }

}


