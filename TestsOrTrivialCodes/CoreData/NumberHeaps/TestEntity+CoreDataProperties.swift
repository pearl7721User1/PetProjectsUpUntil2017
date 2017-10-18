//
//  TestEntity+CoreDataProperties.swift
//  NumberHeaps
//
//  Created by SeoGiwon on 18/10/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//
//

import Foundation
import CoreData


extension TestEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestEntity> {
        return NSFetchRequest<TestEntity>(entityName: "TestEntity")
    }

    @NSManaged public var id: Int16
    @NSManaged public var relationship: NSSet?

}

// MARK: Generated accessors for relationship
extension TestEntity {

    @objc(addRelationshipObject:)
    @NSManaged public func addToRelationship(_ value: Okay)

    @objc(removeRelationshipObject:)
    @NSManaged public func removeFromRelationship(_ value: Okay)

    @objc(addRelationship:)
    @NSManaged public func addToRelationship(_ values: NSSet)

    @objc(removeRelationship:)
    @NSManaged public func removeFromRelationship(_ values: NSSet)

}
