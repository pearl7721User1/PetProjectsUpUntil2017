//
//  Podcast+CoreDataClass.swift
//  SamplePodcast
//
//  Created by SeoGiwon on 22/09/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//
//

import Foundation
import CoreData


public class Podcast: NSManagedObject {

    func describe() -> String {
        var str = "podcast\n"
        str = str + "title: \(title)"  + "episode:\(episodes?.count)"
        
        if let episodes = episodes {
            for episode in episodes {
                
                if let episode = episode as? Episode {
                    
                    str = str + "======================="
                    str = str + "title:\(episode.title)" + "description:\(episode.description)" + "pubDate:\(episode.pubDate)" + "link:\(episode.audioLink ?? "")" + "guid: \(episode.guid)"
                    str = str + "======================="
                }
                
            }
        }
        
        
        return str
    }
    
    func latestPodcastUpdateDate() -> NSDate? {
        
        // find the latest episode
        guard let episodes = self.episodes else {
            print("Episodes doesn't exist. can't happen")
            return nil
        }
        
        let sortPubDate = NSSortDescriptor(key: "pubDate", ascending: false)
        guard let sortedEpisodes = episodes.sortedArray(using: [sortPubDate]) as? [Episode] else {
            
            print("latestPodcastUpdateDate sorting failed")
            return nil
        }
        
        if let latestEpisode = sortedEpisodes.first as? Episode {
            
            return latestEpisode.pubDate
        }
        
        return nil
    }
    
    /// import new episodes by parsing rssFeed
    func updatePodcast(completion: @escaping (_ finished: Bool) -> Void) {
        
        guard let rssFeedLink = self.rssFeedLink else {
            print("can't happen")
            completion(false)
            return
        }
        
        PodcastParser.shared.podcast(rssFeedURL: rssFeedLink) { (podcastJSON: [String : Any]?) in
            
            // parse podcast json
            guard let podcastJSON = podcastJSON,
                let podcastTitle = podcastJSON["title"] as? String,
                let podcastImageData = podcastJSON["imageData"] as? NSData,
                let episodesJSON = podcastJSON["episodes"] as? [[String: Any]] else {
                    completion(false)
                    return
            }
            
            // update podcast's properties
            // podcast title
            self.title = podcastTitle
            
            // podcast image
            self.image = podcastImageData
            
            guard let episodes = self.episodes else {
                print("Episodes doesn't exist. can't happen")
                completion(false)
                return
            }
            
            guard let context = self.managedObjectContext else {
                print("NSManagedContext doesn't exist. can't happen")
                completion(false)
                return
            }
            
            for episodeJSON in episodesJSON {
                
                if let guid = episodeJSON["guid"] as? String,
                    let title = episodeJSON["title"] as? String,
                    let episodeDescription = episodeJSON["episodeDescription"] as? String,
                    let pubDate = episodeJSON["pubDate"] as? NSDate,
                    let audioLink = episodeJSON["audioLink"] as? String,
                    let fileSize = episodeJSON["fileSize"] as? String {
                    
                    // search if an episode with the given guid exists in 'episodes'
                    let predicate = NSPredicate(format: "guid = %@", guid)
                    let filteredEpisodes = episodes.filtered(using: predicate)
                    
                    if filteredEpisodes.count <= 0 {
                        // doesn't exist
                        // newly create
                        let newEpisode = Episode(context: context)
                        
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
                        self.addToEpisodes(newEpisode)
                        
                    } else {
                        
                        guard let existingEpisode = episodes.allObjects.first as? Episode else {
                            print("existingEpisode doesn't exist. can't happen")
                            continue
                        }
                        
                        // title
                        existingEpisode.title = title
                        
                        // description
                        existingEpisode.episodeDescription = episodeDescription
                        
                        // pubdate
                        existingEpisode.pubDate = pubDate as NSDate
                        
                        // audio link
                        existingEpisode.audioLink = audioLink
                        
                        // file size
                        existingEpisode.fileSize = fileSize
                        
                    }
                    
                } else {
                    print("shouldn't happen")
                    
                    if let guid = episodeJSON["guid"] as? String {
                        
                        if let title = episodeJSON["title"] as? String {
                            
                            
                            if let episodeDescription = episodeJSON["episodeDescription"] as? String {
                                
                                
                                if let pubDate = episodeJSON["pubDate"] as? NSDate {
                                    
                                    
                                    if let audioLink = episodeJSON["audioLink"] as? String {
                                        
                                        if let fileSize = episodeJSON["fileSize"] as? String {
                                            
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                    
                    
                }
                
            }
            // end of for statement
            
            print("reached the end of for statement")
            
            completion(true)
            
        }
    }
    
}
