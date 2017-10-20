//
//  Podcast.swift
//  RSSParsingTest
//
//  Created by SeoGiwon on 03/08/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

@objc protocol FeedParserDelegate {
    @objc optional func feedParser(_ parser: FeedParser, didParseChannel channel: FeedChannel)
    @objc optional func feedParser(_ parser: FeedParser, didParseItem item: FeedItem)
    @objc optional func feedParser(_ parser: FeedParser, successfullyParsedURL url: String)
    @objc optional func feedParser(_ parser: FeedParser, parsingFailedReason reason: String)
    @objc optional func feedParserParsingAborted(_ parser: FeedParser)
}

class PodcastParser: FeedParserDelegate {


    private (set) static var shared: PodcastParser = PodcastParser()
    
    typealias PodcastParserCompletion = ([String: Any]?) -> Void

    
    var podcastJSON = [String: Any]()
    
    private func renewPodcastJSON() {
        
        podcastJSON.removeAll()
        podcastJSON["episodes"] = [[String:Any]]()
    }
    
    func podcast(rssFeedURL: String, completion: @escaping PodcastParserCompletion) {

        DispatchQueue.global().async {
            
            self.renewPodcastJSON()
            
            let parser = FeedParser(feedURL: rssFeedURL)
            parser.delegate = self
            
            // start parsing
            parser.parse()

            let json = self.podcastJSON
            
            completion(self.podcastJSON)
            
            return
        }
    }
    
    func feedParser(_ parser: FeedParser, didParseChannel channel: FeedChannel) {
        // Here you could react to the FeedParser identifying a feed channel.
        self.configurePodcastJSON(from: channel)
        print("Feed parser did parse channel \(channel)")

    }
    
    func feedParser(_ parser: FeedParser, didParseItem item: FeedItem) {
        print("Feed parser did parse item \(item.feedTitle)")

            
        if var existingEpisodes = self.podcastJSON["episodes"] as? [[String:Any]]{
            
            existingEpisodes.append(self.episodeJSON(from: item))
            self.podcastJSON["episodes"] = existingEpisodes
        }
        
    }

    
    private func configurePodcastJSON(from feedChannel: FeedChannel) {
        podcastJSON["title"] = feedChannel.channelTitle
        podcastJSON["lastBuildDate"] = feedChannel.channelDateOfLastChange
        
        if let urlString = feedChannel.channelLogoURL,
            let url = URL(string: urlString),
            let data = try? Data(contentsOf: url) {
            podcastJSON["imageData"] = data
        }
    }
 
    
    private func episodeJSON(from feedItem: FeedItem) -> [String: Any] {
        var itemJSON = [String:Any]()
        itemJSON["guid"] = feedItem.feedIdentifier
        itemJSON["title"] = feedItem.feedTitle
        itemJSON["episodeDescription"] = feedItem.feedContent
        itemJSON["pubDate"] = feedItem.feedPubDate
        
        if let feedEnclosure = feedItem.feedEnclosures.first {
            itemJSON["audioLink"] = feedEnclosure.url
            itemJSON["fileSize"] = ByteCountFormatter.string(fromByteCount: Int64(feedEnclosure.length), countStyle: .binary)
        }

        return itemJSON
    }
}
