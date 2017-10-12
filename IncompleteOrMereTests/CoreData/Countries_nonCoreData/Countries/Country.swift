//
//  Country.swift
//  Countries
//
//  Created by SeoGiwon on 06/07/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

struct Country {

    static func read() -> [Country] {
        let plistPath = Bundle.main.path(forResource: "Countries", ofType: "plist")

        var countries = [Country]()
        
        
        if let array = NSArray(contentsOf: URL(fileURLWithPath: plistPath!, isDirectory: false)) as? Array<[String: String]> {

            for dict in array {
                
                var country = Country()
                country.name = dict["name"]
                country.capital = dict["capital"]
                country.area = dict["area"]
                country.population = dict["population"]
                country.continent = dict["continent"]
                country.tId = dict["tId"]
                country.currency = dict["currency"]
                country.phone = dict["phone"]

                countries.append(country)
            }
        }
        
        return countries
    }
    
    var name: String?
    var capital: String?
    var area: String?
    var population: String?
    var continent: String?
    var tId: String?
    var currency: String?
    var phone: String?
    
    
}
