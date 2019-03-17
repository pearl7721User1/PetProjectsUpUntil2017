//
//  DownloadItem+CoreDataProperties.swift
//  DownloadControllerTest
//
//  Created by SeoGiwon on 02/08/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import Foundation
import CoreData


extension DownloadItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DownloadItem> {
        return NSFetchRequest<DownloadItem>(entityName: "DownloadItem")
    }

    @NSManaged public var downloadStatus: Int16
    @NSManaged public var downloadTaskIdentifier: Int16
    @NSManaged public var progress: Float
    @NSManaged public var resumeData: NSData?
    @NSManaged public var title: String?
    @NSManaged public var downloadLinkUrlStr: String?

}
