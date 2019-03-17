//
//  AppDelegate.swift
//  SamplePodcast
//
//  Created by SeoGiwon on 17/08/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coreDataStack = CoreDataStack()
    
    var backgroundSessionCompletionHandler: (() -> Void)?


    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
        print("handleEvents called")
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let podcastFetchRequest: NSFetchRequest<Podcast> = Podcast.fetchRequest()
        if let podcasts = try? coreDataStack.context.count(for: podcastFetchRequest) {
            print("podcast: \(podcasts)")
        }
        
        let episodeFetchRequest: NSFetchRequest<Episode> = Episode.fetchRequest()
        if let episodes = try? coreDataStack.context.count(for: episodeFetchRequest) {
            print("episodes: \(episodes)")
        }
        
        let availableRSSFeedFetchRequest: NSFetchRequest<AvailableRSSFeed> = AvailableRSSFeed.fetchRequest()
        if let rssFeeds = try? coreDataStack.context.count(for: availableRSSFeedFetchRequest) {
            print("rssFeeds: \(rssFeeds)")
        }
        
        
        
        DownloadControllerCollection.shared.loadPodcasts()
//        coreDataStack.importPodcastFromRSS(id: 0) { (finished) in
            
//            print("finisihed")
//        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        DownloadControllerCollection.shared.saveDownloads()
        coreDataStack.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        DownloadControllerCollection.shared.saveDownloads()
        coreDataStack.saveContext()
    }


}

