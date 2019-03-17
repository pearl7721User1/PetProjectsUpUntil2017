//
//  AvailablePodcastTableViewController.swift
//  SamplePodcast
//
//  Created by SeoGiwon on 05/10/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData

class AvailableRSSFeedTableViewController: UITableViewController {

    var coreDataStack: CoreDataStack {
        
        return (UIApplication.shared.delegate as! AppDelegate).coreDataStack
        
    }

    @IBAction func btnTapped(_ sender: UIBarButtonItem) {
        
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
    }
    
    private let rssFeedList:[[String:String]] = {
        
        
        let feed1 = ["title":"All Ears English", "id":"0", "link":"http://allearsenglish.libsyn.com/rss"]
        
        let feed2 = ["title":"English We Speak", "id":"1", "link":"https://podcasts.files.bbci.co.uk/p02pc9zn.rss"]

        let feed3 = ["title":"Snap Judgement", "id":"2", "link":"http://feeds.wnyc.org/snapjudgment-wnyc"]

        let feed4 = ["title":"Ted Radio Hour", "id":"3", "link":"https://www.npr.org/rss/podcast.php?id=510298"]

        
        var feeds = [[String:String]]()
        feeds.append(feed1)
        feeds.append(feed2)
        feeds.append(feed3)
        feeds.append(feed4)
        
        let sorted = feeds.sorted(by: { (feedLeft: [String: String], feedRight: [String: String]) -> Bool in
            
            guard let titleLeft = feedLeft["title"],
                let titleRight = feedRight["title"] else {
                return true
            }
            
            return titleLeft < titleRight
        })
        
        return sorted
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rssFeedList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleCell", for: indexPath)

        // Configure the cell...
        if let title = (rssFeedList[indexPath.row])["title"] {
             cell.textLabel?.text = title
        }
        
        
        if let id = (rssFeedList[indexPath.row])["id"],
            let intID = Int(id) {
            if AvailableRSSFeed.isRSSFeedExist(id: intID){
                cell.accessoryType = .checkmark
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        guard let id = (rssFeedList[indexPath.row])["id"],
            let intID = Int(id) else {
            return
        }
        
        if !AvailableRSSFeed.isRSSFeedExist(id: intID){
                
            // create nsmanaged object
            if AvailableRSSFeed.addRSSFeed(dict: rssFeedList[indexPath.row]) {
                
                
                DispatchQueue.main.async {
                    
                    self.coreDataStack.newlyAddPodcastFromRSSList(id: intID, completion: { (finished: Bool) in
                        
                        DispatchQueue.main.async {
                            
                            tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                        
                    })
                }
                
                
            }
            
            
        }
        
        /*
        if !UserDefaultsController.shared.isRSSFeedRegistered(id: Int(rssFeedList[indexPath.row].id)) {
            UserDefaultsController.shared.registerRSSFeed(id: Int(rssFeedList[indexPath.row].id))
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        */
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
