//
//  File.swift
//  WorldCupSample
//
//  Created by SeoGiwon on 4/26/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class CompetitionRecords: NSObject, NSCoding {
    
    var imageName: String?
    var qualifyingZone: String?
    var teamName: String?
    var wins: Int32
    
    init(imageName: String, qualifyingZone: String, teamName: String, wins: Int32) {
        
        self.imageName = imageName
        self.qualifyingZone = qualifyingZone
        self.teamName = teamName
        self.wins = wins
    }
    
    required init(coder aDecoder: NSCoder) {
        
        imageName = aDecoder.decodeObject(forKey: "imageName") as? String
        qualifyingZone = aDecoder.decodeObject(forKey: "qualifyingZone") as? String
        teamName = aDecoder.decodeObject(forKey: "teamName") as? String
        wins = aDecoder.decodeInt32(forKey: "wins") as Int32
        
    }
    
    func encode(with aCoder: NSCoder) {
     
        aCoder.encode(imageName ?? "", forKey: "imageName")
        aCoder.encode(qualifyingZone ?? "", forKey: "qualifyingZone")
        aCoder.encode(teamName ?? "", forKey: "teamName")
        aCoder.encode(wins, forKey: "wins")
        
    }
    
    static func filteredRecords(with qualifyingZone: String) -> [CompetitionRecords]? {
        
        guard let competitionRecords = CompetitionRecords.competitionRecords() else {
            return nil
        }
        
        let newRecords = competitionRecords.filter({$0.qualifyingZone == qualifyingZone})
        return newRecords
    }
    
    static func competitionRecords() -> [CompetitionRecords]? {
        
        return PersistenceManager.load()
    }
    
    static func competitionQualifyingZones() -> [String]? {
        
        if let records = PersistenceManager.load() {

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
        } else {
            return nil
        }
    }
    
    static func save(_ records: [CompetitionRecords]) throws {
        if PersistenceManager.save(records) == true {
            return
        } else {
            throw WorldCupSampleError.sampleInputBundleJSONFileWritingError
        }
    }
    
}
