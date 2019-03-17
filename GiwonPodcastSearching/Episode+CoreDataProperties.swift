//
//  Episode+CoreDataProperties.swift
//  SamplePodcast
//
//  Created by SeoGiwon on 22/09/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//
//

import Foundation
import CoreData


extension Episode {

    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Episode> {
        return NSFetchRequest<Episode>(entityName: "Episode")
    }

    // episode information
    @NSManaged public var episodeDescription: String?
    @NSManaged public var fileSize: String?
    @NSManaged public var guid: String?
    @NSManaged public var pubDate: NSDate?
    @NSManaged public var title: String?

    // download management
    @NSManaged public var audioLink: String?
    @NSManaged public var downloadStatus: Int16
    @NSManaged public var downloadTaskIdentifier: Int16
    @NSManaged public var progress: Float
    @NSManaged public var resumeData: NSData?
    
    // relationship
    @NSManaged public var podcast: Podcast?
}
