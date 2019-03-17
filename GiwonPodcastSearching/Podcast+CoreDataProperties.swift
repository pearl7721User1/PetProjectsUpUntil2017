//
//  Podcast+CoreDataProperties.swift
//  SamplePodcast
//
//  Created by SeoGiwon on 22/09/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//
//

import Foundation
import CoreData


extension Podcast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Podcast> {
        return NSFetchRequest<Podcast>(entityName: "Podcast")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var title: String?
    @NSManaged public var rssFeedLink: String?
    @NSManaged public var episodes: NSSet?

}

// MARK: Generated accessors for episodes
extension Podcast {

    @objc(addEpisodesObject:)
    @NSManaged public func addToEpisodes(_ value: Episode)

    @objc(removeEpisodesObject:)
    @NSManaged public func removeFromEpisodes(_ value: Episode)

    @objc(addEpisodes:)
    @NSManaged public func addToEpisodes(_ values: NSSet)

    @objc(removeEpisodes:)
    @NSManaged public func removeFromEpisodes(_ values: NSSet)

}
