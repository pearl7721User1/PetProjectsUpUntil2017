//
//  CountriesTests.swift
//  CountriesTests
//
//  Created by SeoGiwon on 06/07/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import XCTest
@testable import Countries
import CoreData

class CountriesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testInitCountries() {
        
        (UIApplication.shared.delegate as! AppDelegate).removeAll()
        (UIApplication.shared.delegate as! AppDelegate).importIfPossible()
        
        XCTAssertEqual(countryInputTotal(), countriesTotalInCoreData())
        
        
        
        let countryJSONs = Country.createExtraCountries()
        
        for json in countryJSONs {
            
            if let country = Country.findOrCreate(json: json) {
                country.population = json["population"] as? String
                country.capital = json["capital"] as? String
                country.continent = json["continent"] as? String
                country.name = json["name"] as? String
            }
            
        }
        
        XCTAssertEqual(countryInputTotal(), countriesTotalInCoreData() - countryJSONs.count)
        
        let newCountryJSONs = Country.createExtraCountries()
        
        for json in newCountryJSONs {
            
            if let country = Country.findOrCreate(json: json) {
                country.population = json["population"] as? String
                country.capital = json["capital"] as? String
                country.continent = json["continent"] as? String
                country.name = json["name"] as? String
                
                XCTAssert(country.population != nil)
                XCTAssert(country.capital != nil)
                XCTAssert(country.continent != nil)
                XCTAssert(country.name != nil)
            }
            
        }

        XCTAssertEqual(countryInputTotal(), countriesTotalInCoreData() - countryJSONs.count)
        
        
        
    }
    
    func countryInputTotal() -> Int {
        
        let plistPath = Bundle.main.path(forResource: "Countries", ofType: "plist")
        
        guard let array = NSArray(contentsOf: URL(fileURLWithPath: plistPath!, isDirectory: false)) as? Array<[String: String]> else {
            
            XCTFail()
            return -1
        }
        
        return array.count
    }
    
    func countriesTotalInCoreData() -> Int {
        
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        
        if let result = try? (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(fetchRequest).count {
            return result
        } else {
            return -1
        }
    }
}
