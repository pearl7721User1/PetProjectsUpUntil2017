//
//  Okay+CoreDataProperties.swift
//  NumberHeaps
//
//  Created by SeoGiwon on 22/09/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//
//

import Foundation
import CoreData


extension Okay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Okay> {
        return NSFetchRequest<Okay>(entityName: "Okay")
    }

    @NSManaged public var hey: Hey?

    @NSManaged public var name: String?
}
