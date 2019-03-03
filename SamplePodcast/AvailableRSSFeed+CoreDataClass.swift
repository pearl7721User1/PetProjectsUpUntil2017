//
//  AvailableRSSFeed+CoreDataClass.swift
//  SamplePodcast
//
//  Created by SeoGiwon on 06/10/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//
//

import UIKit
import CoreData


public class AvailableRSSFeed: NSManagedObject {
    
    
    static func isRSSFeedExist(id: Int) -> Bool {
        
        // search core data with id as predicate
        let context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.context
        
        let fetchRequest: NSFetchRequest<AvailableRSSFeed> = AvailableRSSFeed.fetchRequest()
        let predicate = NSPredicate(format: "id = %d", id)
        fetchRequest.predicate = predicate
        
        
        guard let rssFeedCount = try? context.count(for: fetchRequest) else {
            return false
        }
        
        return rssFeedCount > 0 ? true : false
    }
    
    static func rssFeed(id: Int) -> AvailableRSSFeed? {
        // search core data with id as predicate
        let context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.context
        
        let fetchRequest: NSFetchRequest<AvailableRSSFeed> = AvailableRSSFeed.fetchRequest()
        let predicate = NSPredicate(format: "id = %d", id)
        fetchRequest.predicate = predicate
        
        guard let rssFeedList = try? context.fetch(fetchRequest),
            let rssFeed = rssFeedList.first else {
            return nil
        }
        
        return rssFeed
    }

    static func addRSSFeed(dict: [String:String]) -> Bool{
        
        // search core data with id as predicate
        let context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.context
        
        // parse dictionary
        guard let title = dict["title"],
            let id = dict["id"],
            let intID = Int16(id),
            let link = dict["link"] else {
                return false
        }
        
        let feed = AvailableRSSFeed(context: context)
        feed.title = title
        feed.link = link
        feed.id = intID
        
        do {
            try context.save()
        } catch {
            return false
        }
        
        return true
    }
    
    
}
