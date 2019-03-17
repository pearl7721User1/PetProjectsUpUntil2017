//
//  UserDefaultController.swift
//  SamplePodcast
//
//  Created by SeoGiwon on 05/10/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class UserDefaultsController: NSObject {

    private (set) static var shared: UserDefaultsController = UserDefaultsController()
    
    func isRSSFeedRegistered(id: Int) -> Bool {
        
        if let addedFeedIDList = UserDefaults.standard.value(forKey: "RSSFeeds") as? [Int] {
            let filteredList = addedFeedIDList.filter({$0 == id})
            
            if filteredList.count == 1 {
                return true
            }
        }
        
        return false
    }
    
    func registerRSSFeed(id: Int) {
        
        // first time ever executed
        if UserDefaults.standard.value(forKey: "RSSFeeds") == nil {
            UserDefaults.standard.set([Int](), forKey: "RSSFeeds")
        }
        
        
        if var addedFeedIDList = UserDefaults.standard.value(forKey: "RSSFeeds") as? [Int] {
            addedFeedIDList.append(id)
            UserDefaults.standard.set(addedFeedIDList, forKey: "RSSFeeds")
        } else {
            print("registerRSSFeed() failed")
        }
        
        
    }
}
