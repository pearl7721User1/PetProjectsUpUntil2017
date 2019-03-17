//
//  AvailableRSSFeed+CoreDataProperties.swift
//  SamplePodcast
//
//  Created by SeoGiwon on 06/10/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//
//

import Foundation
import CoreData


extension AvailableRSSFeed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AvailableRSSFeed> {
        return NSFetchRequest<AvailableRSSFeed>(entityName: "AvailableRSSFeed")
    }

    @NSManaged public var title: String?
    @NSManaged public var id: Int16
    @NSManaged public var link: String?

}
