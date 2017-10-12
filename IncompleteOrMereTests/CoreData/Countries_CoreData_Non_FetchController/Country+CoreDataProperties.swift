//
//  Country+CoreDataProperties.swift
//  Countries
//
//  Created by SeoGiwon on 07/07/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var name: String?
    @NSManaged public var capital: String?
    @NSManaged public var population: String?
    @NSManaged public var continent: String?

}
