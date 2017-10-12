//
//  ViewController.swift
//  WorldCupSample
//
//  Created by SeoGiwon on 4/26/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit


enum WorldCupSampleError: Error {
    case sampleInputBundleJSONReadingError(String)
    case sampleInputBundleJSONFileWritingError
}

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

class ViewController: UIViewController {
    
    lazy var competitionRecords: [CompetitionRecords]? = {
       
        let records = CompetitionRecords.competitionRecords()
        return records
    }()
    
    lazy var sectionTitles: [String]? = {
        
        let titles = CompetitionRecords.competitionQualifyingZones()
        
        return titles
    }()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        if PersistenceManager.load() == nil {
            do {
                
                try writeSampleInput()
            } catch WorldCupSampleError.sampleInputBundleJSONReadingError(let desc) {
                print(desc)
            } catch let error as Error {
                print(error.localizedDescription)
                
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sectionStartIndex = indexForSectionStart(with: indexPath.section)

        let theIndex = sectionStartIndex + indexPath.row
        
        guard let competitionRecords = competitionRecords else {
            return
        }
        
        let theRecords = competitionRecords[theIndex]
        theRecords.wins += 1
        tableView.reloadRows(at: [indexPath], with: .fade)
            
        do {
            try CompetitionRecords.save(competitionRecords)
        } catch let error as WorldCupSampleError {
            print(error.localizedDescription)
        } catch let error as Error {
            print(error.localizedDescription)
        }
        
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles?[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        guard let sectionTitles = self.sectionTitles,
            let competitionRecords = self.competitionRecords else {
            return cell
        }
        
        let sectionTitle = sectionTitles[indexPath.section]
        let filteredRecords = competitionRecords.filter({$0.qualifyingZone == sectionTitle})
        
        
        if let teamNameLB = cell.viewWithTag(1) as? UILabel {
            teamNameLB.text = filteredRecords[indexPath.row].teamName
        }
        
        if let winsLB = cell.viewWithTag(3) as? UILabel {
            winsLB.text = String(filteredRecords[indexPath.row].wins)
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let competitionRecords = self.competitionRecords,
            let sectionTitles = self.sectionTitles else {
            return 0
        }
        
        let sectionTitle = sectionTitles[section]
        let records = competitionRecords.filter({$0.qualifyingZone == sectionTitle})
        
        return records.count
    }
    
    fileprivate func indexForSectionStart(with index:Int) -> Int {
        
        guard let sectionTitle = sectionTitles?[index],
            let competitionRecords = competitionRecords else {
                return -1
        }
        
        var i: Int = 0
        
        for records in competitionRecords {
            if records.qualifyingZone == sectionTitle {
                break
            }
            i += 1
        }
        
        return i
    }
    
    func writeSampleInput() throws {
        
        guard let jsonURL = Bundle.main.url(forResource: "Records", withExtension: "json"),
            let jsonData = try? Data(contentsOf: jsonURL) as Data,
            let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]),
            let jsonArray = jsonObject as? [AnyObject] else {
            throw WorldCupSampleError.sampleInputBundleJSONReadingError("Filaasdfsfsdf")
        }
        
        var competitionRecords = [CompetitionRecords]()
        
        for jsonDictionary in jsonArray {
            guard let teamName = jsonDictionary["teamName"] as? String else {
                throw SerializationError.missing("teamName")
            }
            
            guard let zone = jsonDictionary["qualifyingZone"] as? String else {
                throw SerializationError.missing("qualifyingZone")
            }
            
            guard let imageName = jsonDictionary["imageName"] as? String else {
                throw SerializationError.missing("imageName")
            }
            
            guard let wins = jsonDictionary["wins"] as? Int32 else {
                throw SerializationError.missing("wins")
            }
            
            let records = CompetitionRecords(imageName: imageName, qualifyingZone: zone, teamName: teamName, wins: wins)
            
            competitionRecords.append(records)
        }
        
        do {
            try CompetitionRecords.save(competitionRecords)
        }
        catch let error as WorldCupSampleError {
            print(error.localizedDescription)
            throw error
        }
    }
}



/*
 func testRecordsFiltering() {
 
 let records: [CompetitionRecords] = {
 let record1 = CompetitionRecords(imageName: "Congo.jpg", qualifyingZone: "Africa", teamName: "Congo", wins: 1)
 let record2 = CompetitionRecords(imageName: "Spain.jpg", qualifyingZone: "Europe", teamName: "Spain", wins: 2)
 let record3 = CompetitionRecords(imageName: "Korea.jpg", qualifyingZone: "Asia", teamName: "Korea", wins: 2)
 let record4 = CompetitionRecords(imageName: "Japan.jpg", qualifyingZone: "Asia", teamName: "Japan", wins: 2)
 let record5 = CompetitionRecords(imageName: "China.jpg", qualifyingZone: "NorthAmerica", teamName: "China", wins: 2)
 let record6 = CompetitionRecords(imageName: "Australia.jpg", qualifyingZone: "Africa", teamName: "Australia", wins: 2)
 
 return [record1, record2, record3, record4, record5, record6]
 }()
 
 
 let qzArray = stringArray("qualifyingZone", from: records)
 
 
 }
 
 func stringArray(_ key:String, from records:[CompetitionRecords]) -> [String] {
 
 var QZArray = [String]()
 
 for index in 0...records.count-1 {
 
 if (index == 0) {
 QZArray.append(records[index].qualifyingZone ?? "")
 }
 else {
 let stringAtTheMoment = records[index].qualifyingZone
 
 if (!QZArray.contains(stringAtTheMoment ?? "")) {
 QZArray.append(stringAtTheMoment ?? "")
 }
 
 }
 }
 
 return QZArray
 }
 
 
 func testSaveLoadFunctions() {
 /*
 let records: [CompetitionRecords] = {
 let record1 = CompetitionRecords(imageName: "Congo.jpg", losses: 1, qualifyingZone: "Africa", teamName: "Congo", wins: 1)
 let record2 = CompetitionRecords(imageName: "Spain.jpg", losses: 0, qualifyingZone: "Europe", teamName: "Spain", wins: 2)
 
 return [record1, record2]
 }()
 
 XCTAssertTrue(PersistenceManager.save(records))
 */
 
 var loadedRecords: [CompetitionRecords]?
 XCTAssertNotNil(loadedRecords = PersistenceManager.load())
 
 
 }
 
 func testInputs() {
 var jsonData: Data?
 
 do {
 jsonData = try JSONSerialization.data(withJSONObject: getInputData(), options: [])
 } catch {
 
 }
 
 let backToString = String(data: jsonData!, encoding: String.Encoding.utf8) as String!
 
 PersistenceManager.saveToTextFile(str: backToString!)
 
 }
 
 func getInputData() -> [[String:Any]] {
 
 let record1 = ["teamName":"Algeria", "qualifyingZone":"Africa", "imageName":"algeria-flag", "wins":0] as [String : Any]
 let record2 = ["teamName":"Cameroon", "qualifyingZone":"Africa", "imageName":"cameroon-flag", "wins":0] as [String : Any]
 let record3 = ["teamName":"Ivory Coast", "qualifyingZone":"Africa", "imageName":"Ivory Coast-flag", "wins":0] as [String : Any]
 
 return [record1, record2, record3]
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
 
 
 */
