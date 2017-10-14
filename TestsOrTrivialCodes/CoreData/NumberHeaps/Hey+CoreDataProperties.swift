//
//  Hey+CoreDataProperties.swift
//  NumberHeaps
//
//  Created by SeoGiwon on 22/09/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//
//

import Foundation
import CoreData


extension Hey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Hey> {
        return NSFetchRequest<Hey>(entityName: "Hey")
    }

    @NSManaged public var number: Int32
    @NSManaged public var title: String?
    @NSManaged public var okays: NSSet?

}

// MARK: Generated accessors for okays
extension Hey {

    @objc(addOkaysObject:)
    @NSManaged public func addToOkays(_ value: Okay)

    @objc(removeOkaysObject:)
    @NSManaged public func removeFromOkays(_ value: Okay)

    @objc(addOkays:)
    @NSManaged public func addToOkays(_ values: NSSet)

    @objc(removeOkays:)
    @NSManaged public func removeFromOkays(_ values: NSSet)

}
