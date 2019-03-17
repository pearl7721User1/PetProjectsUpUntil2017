//
//  EpisodeViewController.swift
//  SamplePodcast
//
//  Created by SeoGiwon on 20/10/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class EpisodeViewController: UIViewController {

    var refreshControl: UIRefreshControl!
    
    var podcast: Podcast!
    
    @IBOutlet weak var headerView: EpisodeViewControllerHeader!
    @IBOutlet weak var tableView: UITableView!
    
    
    var podcastArtWork: UIImage? {
        get {
            return headerView.artWorkView?.image
        }
        
        set {
            headerView.artWorkView?.image = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        headerView.height = EpisodeViewControllerHeader.HeightCompactMax
        
        
        // configure podcast in the view
        if let artwork = podcast.image {
            podcastArtWork = UIImage(data: artwork as Data)
        }

    }
    
    func refresh() {
        print("asdfas")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension EpisodeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < 0 {
            
            self.headerView.height = EpisodeViewControllerHeader.HeightCompactMax
            
        } else if scrollView.contentOffset.y > EpisodeViewControllerHeader.HeightCompactMax-EpisodeViewControllerHeader.HeightCompactMin {
            
            self.headerView.height = EpisodeViewControllerHeader.HeightCompactMin
            
        } else {
            
            self.headerView.height = EpisodeViewControllerHeader.HeightCompactMax - scrollView.contentOffset.y
            
        }
 
    }
    
}

extension EpisodeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        
        if let episodes = podcast.episodes?.allObjects as? [Episode] {
            
            if let episodeTitle = episodes[indexPath.row].title as? String,
                let podcastTitle = episodes[indexPath.row].podcast?.title as? String {
                
                let t = podcastTitle + " : " + episodeTitle
                
                cell.textLabel?.text = t
            }
            
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return podcast.episodes?.allObjects.count ?? 0
    }
}
