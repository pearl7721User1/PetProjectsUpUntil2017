//
//  SamplePodcastTests.swift
//  SamplePodcastTests
//
//  Created by SeoGiwon on 17/08/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import XCTest
import CoreData
@testable import SamplePodcast

class SamplePodcastTests: XCTestCase {
    
    let testRSSFeedDict = ["title":"BBC Drama", "id":"999", "link":"https://podcasts.files.bbci.co.uk/p02pc9s1.rss"]
    let testRSSFeedLink = "https://podcasts.files.bbci.co.uk/p02pc9s1.rss"
    let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.context
    let coreDataStack = (UIApplication.shared.delegate as! AppDelegate).coreDataStack
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // delete testRSSFeed from Core Data if any
        // delete AvailableRSSFeed
        let availableRSSFeedFetchRequest: NSFetchRequest<AvailableRSSFeed> = AvailableRSSFeed.fetchRequest()
        
        let availableRSSFeedResults = try! coreDataContext.fetch(availableRSSFeedFetchRequest)
        
        for availableRSSFeed in availableRSSFeedResults {
            coreDataContext.delete(availableRSSFeed)
        }
        
        
        // fetch the Podcast of testRSSFeed if any
        let podcastFetchRequest: NSFetchRequest<Podcast> = Podcast.fetchRequest()
        let podcastPredicate = NSPredicate(format: "rssFeedLink = %@", testRSSFeedLink)
        podcastFetchRequest.predicate = podcastPredicate
        
        // delete all episodes in the podcast
        let podcastRSSFeedResults = try! coreDataContext.fetch(podcastFetchRequest)
        
        if let podcast = podcastRSSFeedResults.first {
            
            for anyEpisode in podcast.episodes!.allObjects {
                
                if let episode = anyEpisode as? Episode {
                    coreDataContext.delete(episode)
                }
                
            }
            
            coreDataContext.delete(podcast)
        }
        
        
        
        // delete the podcast of RandomPodcast if any
        let testPodcastFetchRequest: NSFetchRequest<Podcast> = Podcast.fetchRequest()
        let testPodcastPredicate = NSPredicate(format: "title = %@", "RandomPodcast")
        testPodcastFetchRequest.predicate = testPodcastPredicate
        
        // delete all episodes in the podcast
        let testPodcastRSSFeedResults = try! coreDataContext.fetch(testPodcastFetchRequest)
        
        if let testPodcast = testPodcastRSSFeedResults.first {
            
            for anyEpisode in testPodcast.episodes!.allObjects {
                
                if let episode = anyEpisode as? Episode {
                    coreDataContext.delete(episode)
                }
                
            }
            
            coreDataContext.delete(testPodcast)
        }
        
        
        testAddingRSSFeedAndParsing()
    }
    
    
    func testAddingRSSFeedAndParsing() {
        
        // if it already exists for some reasons do not test it
        guard AvailableRSSFeed.isRSSFeedExist(id: Int(testRSSFeedDict["id"]!)!) == false else {
            return
        }
        
        
        // add test feed to core data
        XCTAssert(AvailableRSSFeed.addRSSFeed(dict: testRSSFeedDict) == true)

        // see if it resides in core data
        XCTAssert(AvailableRSSFeed.isRSSFeedExist(id: Int(testRSSFeedDict["id"]!)!) == true)
        
        // read the test feed link from core data
        guard let rssFeed = AvailableRSSFeed.rssFeed(id: Int(testRSSFeedDict["id"]!)!),
            let feedLink = rssFeed.link else {
                
            XCTFail()
            return
        }

        XCTAssert(Int16(testRSSFeedDict["id"]!)! == rssFeed.id)
        XCTAssert(testRSSFeedDict["title"]! == "BBC Drama")
        XCTAssert(testRSSFeedDict["link"]! == "https://podcasts.files.bbci.co.uk/p02pc9s1.rss")
        
        let responseExpectation = expectation(description: "PodcastRSSFeedParsing")
        
        PodcastParser.shared.podcast(rssFeedURL: feedLink) { (podcastJSON: [String : Any]?) in
         
            // parse podcast json
            guard let podcastJSON = podcastJSON,
                let podcastTitle = podcastJSON["title"] as? String,
                let podcastImageData = podcastJSON["imageData"] as? NSData,
                let episodesJSON = podcastJSON["episodes"] as? [[String: Any]] else {
                    
                    XCTFail()
                    return
            }

            
            // fetch podcast
            let newPodcast = Podcast(context: self.coreDataContext)
            
            // podcast title
            newPodcast.title = podcastTitle
            
            // podcast image
            newPodcast.image = podcastImageData
            
            // podcast rss feed
            newPodcast.rssFeedLink = feedLink
            
            
            for episodeJSON in episodesJSON {
                
                if let guid = episodeJSON["guid"] as? String,
                    let title = episodeJSON["title"] as? String,
                    let episodeDescription = episodeJSON["episodeDescription"] as? String,
                    let pubDate = episodeJSON["pubDate"] as? NSDate,
                    let audioLink = episodeJSON["audioLink"] as? String,
                    let fileSize = episodeJSON["fileSize"] as? String {
                    
                    // newly create
                    let newEpisode = Episode(context: self.coreDataContext)
                    
                    // download identifier
                    newEpisode.downloadTaskIdentifier = -1
                    
                    // guid
                    newEpisode.guid = guid
                    
                    // title
                    newEpisode.title = title
                    
                    // description
                    newEpisode.episodeDescription = episodeDescription
                    
                    // pubdate
                    newEpisode.pubDate = pubDate
                    
                    // audio link
                    newEpisode.audioLink = audioLink
                    
                    // file size
                    newEpisode.fileSize = fileSize
                    
                    // add to the podcast
                    newPodcast.addToEpisodes(newEpisode)
                    
                } else {
                    XCTFail()
                    return
                }
            }
            
            responseExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler:nil)
        
        
    }

    
    func testLatestPodcastUpdateDate() {
        
        // add test podcast and a couple of episodes to core data
        let podcast = Podcast(context: coreDataContext)
        podcast.title = "RandomPodcast"
        podcast.rssFeedLink = "MyRSSFeedLink"
        
        let randomDates = createRandomDates()
        
        let episode1 = Episode(context: coreDataContext)
        episode1.pubDate = randomDates[0]
        
        let episode2 = Episode(context: coreDataContext)
        episode2.pubDate = randomDates[1]

        let episode3 = Episode(context: coreDataContext)
        episode3.pubDate = randomDates[2]

        let episode4 = Episode(context: coreDataContext)
        episode4.pubDate = randomDates[3]

        let episode5 = Episode(context: coreDataContext)
        episode5.pubDate = randomDates[4]

        
        podcast.addToEpisodes(episode1)
        podcast.addToEpisodes(episode2)
        podcast.addToEpisodes(episode3)
        podcast.addToEpisodes(episode4)
        podcast.addToEpisodes(episode5)
        
        let date = podcast.latestPodcastUpdateDate()
        print(date?.colloquial(isShortForm: false))
    }
    
    
    // MARK: - String Parsing
    func testHTMLDescriptionParsing() {
        
        let html = "<p><strong><a href=\"allearsenglish.com/subscribe\">Click here to subscribe to the transcripts and save 50%</a></strong></p>"
        
        let newDescription = stringByStrippingHTML(html: html)
        print(newDescription)
    }
    
    func stringByStrippingHTML(html: String) -> String {
        
        var nsStr = html as NSString
        
        while (true) {
            
            let r = nsStr.range(of: "<[^>]+>", options: .regularExpression)
            
            if (r.location != NSNotFound) {
                nsStr = nsStr.replacingCharacters(in: r, with: "") as NSString
                
            } else {
                break
            }
        }
        
        return nsStr as String
    }
    
    func testPredicate() {
        
        let data = dict()
        
        
       
    }
    
    // MARK: - Predicate, Keywords
    func dict() -> [String: Any] {
        
        let dict = ["title": "Taylor Swift", "array": randomArray()] as [String : Any]
        /*
//        var predicate: NSPredicate = NSPredicate(format: "ANY array.name like 'Giwon'")
        var predicate: NSPredicate = NSPredicate(format: "%K like %@", "name", "Giwon")
        
        let newArray = (dict as NSDictionary).allValues as NSArray
        
        let filtered = ((dict as NSDictionary).allValues as NSArray).filtered(using: predicate)
        
//        "ANY employees.firstName like 'Matthew'"];
        */
        return dict
    }
    
    func randomArray() -> [[String: String]] {
        
        let dict1 = ["name": "Toronto Pearson", "age": "19"]
        let dict2 = ["name": "Giwon", "age": "30"]
        let dict3 = ["name": "Babo", "age": "20"]
        let dict4 = ["name": "Guitar", "age": "35"]
        let dict5 = ["name": "Charlie", "age": "23"]

        let array = [dict1, dict2, dict3, dict4, dict5] as NSArray
        var predicate: NSPredicate = NSPredicate(format: "%K like %@", "name", "Giwon")
        
        let filtered = array.filtered(using: predicate)
        
        
        
        return [dict1, dict2, dict3, dict4, dict5]
    }
    
}

extension SamplePodcastTests {
    
    func createRandomDates() -> [NSDate] {
        
        var dates = [NSDate]()
        dates.append(nsDate(day: 18, month: 10, year: 2017))
        dates.append(nsDate(day: 19, month: 10, year: 2017))
        dates.append(nsDate(day: 10, month: 10, year: 2017))
        dates.append(nsDate(day: 1, month: 2, year: 2017))
        dates.append(nsDate(day: 19, month: 5, year: 2017))
        
        return dates
    }
    
    func nsDate(day: Int, month: Int, year: Int) -> NSDate {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        components.day = day
        components.month = month
        components.year = year
        
        let date = Calendar.current.date(from: components)
        
        return date as! NSDate
    }
}
