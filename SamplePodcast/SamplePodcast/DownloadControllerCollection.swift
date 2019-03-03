//
//  DownloadControllerCollection.swift
//  SamplePodcast
//
//  Created by SeoGiwon on 22/09/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData

class DownloadControllerCollection {

    private (set) static var shared: DownloadControllerCollection = DownloadControllerCollection()
    
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).coreDataStack.context
    }
    
    var downloadControllers = [DownloadController]()
    
    
    
    func saveDownloads() {
        
        for downloadController in downloadControllers {
            downloadController.saveDownloads()
        }
        
    }
    
    func loadPodcasts() {
        
        // fetch existing podcasts
        let podcastFetchRequest: NSFetchRequest<Podcast> = Podcast.fetchRequest()
        
        // create downloadControllers for the number of podcasts
        if let podcasts = try? context.fetch(podcastFetchRequest) {
            
            for podcast in podcasts {
                
                // distinguish podcasts by its title
                
                guard let podcastTitle = podcast.title else { continue }
                let downloadController = DownloadController(podcastTitle: podcastTitle)
                downloadController.loadEpisodes()
                downloadControllers.append(downloadController)
            }
            
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
