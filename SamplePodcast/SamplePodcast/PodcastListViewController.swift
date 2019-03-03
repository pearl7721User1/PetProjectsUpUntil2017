//
//  ViewController.swift
//  SamplePodcast
//
//  Created by SeoGiwon on 17/08/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData

class PodcastListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
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
    
    lazy var fetchedResultsController : NSFetchedResultsController<Podcast> = {
        
        let fetchRequest: NSFetchRequest<Podcast> = Podcast.fetchRequest()
        let sortTitle = NSSortDescriptor(key: #keyPath(Podcast.title), ascending: true)
        fetchRequest.sortDescriptors = [sortTitle]
        
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: self.coreDataStack.context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: "podcast")
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleCell", for: indexPath)
        
        // configure cell
        let podcast = fetchedResultsController.object(at: indexPath)
        configure(cell: cell, podcast: podcast)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let cnt = fetchedResultsController.sections?[0].numberOfObjects
        
        return cnt ?? 0
    }
    
    func configure(cell: UITableViewCell, podcast: Podcast) {
        
        if let imageData = podcast.image,
            let image = UIImage(data: imageData as Data){
            cell.imageView?.image = image
        }
        
        
        cell.textLabel?.text = podcast.title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let episodeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EpisodeViewController") as? EpisodeViewController {
            
            episodeViewController.podcast = fetchedResultsController.object(at: indexPath)
            self.navigationController?.pushViewController(episodeViewController, animated: true)
        }
        
        
        
    }
}

extension PodcastListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleCell", for: indexPath!)
            let podcast = fetchedResultsController.object(at: indexPath!)
            configure(cell: cell, podcast: podcast)
            
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default: break
        }
    }
}
