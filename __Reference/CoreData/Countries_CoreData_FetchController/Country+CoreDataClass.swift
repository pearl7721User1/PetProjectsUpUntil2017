//
//  Country+CoreDataClass.swift
//  Countries
//
//  Created by SeoGiwon on 07/07/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData


public class Country: NSManagedObject {


    static func createExtraCountries() -> Array<[String: Any]> {
    
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        let plistPath = Bundle.main.path(forResource: "ExtraCountries", ofType: "plist")
        
        var countries = [Country]()
        if let array = NSArray(contentsOf: URL(fileURLWithPath: plistPath!, isDirectory: false)) as? Array<[String: Any]> {

            return array
        }
        else {
            return Array<[String: Any]>()
        }
    }
    
    static func findOrCreate(json: [String: Any]) -> Country? {
        
        guard let name = json["name"] as? String else {
            return nil
        }
        
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        
        if let existingCountries = try? (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(fetchRequest) {
            
            if let lastEntry = existingCountries.last {
                return lastEntry
            } else {
                
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let country = Country(context: context)
                return country
            }
        } else {
            return nil
        }
    }
    
    /*
    static func insert(country: Country) {
        
        print(country.describe())
        
        guard let name = country.name else {
            
            print("country no name")
            
            return
        }
        
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", country.name!)
        
        if let existingCountries = try? (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(fetchRequest) {
            
            if let lastEntry = existingCountries.last {
                print("already exists")
            } else {
                print("willInsert")
                (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.insert(country)
            }
            
        } else {
            print("Don't know")
            return
        }
        
        
    }
    */
 
    func describe() -> String {
        
        let name = self.name ?? ""
        let capital = self.capital ?? ""
        let continent = self.continent ?? ""
        let population = self.population ?? ""
        
        return name + capital + continent + population
    }
}
