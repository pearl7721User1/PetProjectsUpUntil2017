//
//  File.swift
//  WorldCupSample
//
//  Created by SeoGiwon on 4/26/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class PersistenceManager {
    
    class func save(_ records: [CompetitionRecords]) -> Bool {
        
        return NSKeyedArchiver.archiveRootObject(records, toFile: fullPath())
    }
    
    class func saveToTextFile(_ str: String) {
        
        let path = jsonFilePath()
        
        do {
            try str.write(toFile: path, atomically: true, encoding: .utf8)
        } catch {
            
        }
        
        
    }
    
    class func load() -> [CompetitionRecords]? {

        if let records = NSKeyedUnarchiver.unarchiveObject(withFile: fullPath()) as? [CompetitionRecords] {
            return records
        } else { return nil }
    }
    
    class func jsonFilePath() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsDirectoryPath = (documentsPath as NSString).appendingPathComponent("NewerDirectory")
        
        // if directory doesn't exist, create one
        let fileManager = FileManager.default
        
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: documentsDirectoryPath, isDirectory:&isDir), isDir.boolValue == true {
            
        } else {
            do {
                try fileManager.createDirectory(atPath: documentsDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("directory wasn't created")
            }
        }
        
        let fullPath = (documentsDirectoryPath as NSString).appendingPathComponent("jsonSample.txt")
        
        return fullPath
    }
    
    class func fullPath() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsDirectoryPath = (documentsPath as NSString).appendingPathComponent("NewerDirectory")
        
        // if directory doesn't exist, create one
        let fileManager = FileManager.default
        
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: documentsDirectoryPath, isDirectory:&isDir), isDir.boolValue == true {
            
        } else {
            do {
                try fileManager.createDirectory(atPath: documentsDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("directory wasn't created")
            }
        }
        
        let fullPath = (documentsDirectoryPath as NSString).appendingPathComponent("CompetitionRecordsss")
        
        print(fullPath)
        
        return fullPath
    }
    
}
