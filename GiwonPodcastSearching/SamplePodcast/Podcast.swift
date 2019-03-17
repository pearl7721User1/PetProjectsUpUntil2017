//
//  Podcast.swift
//  SamplePodcast
//
//  Created by SeoGiwon on 17/08/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit


class Podcast: NSObject {
    
    var title = ""
    var img: UIImage?
    var pubDate = ""
    var episodes = [Episode]()
    
    func createEpisode() -> Episode {
        let episode = Episode()
        episode.session = session
        return episode
    }
    
    func describe() -> String {
        var str = "podcast\n"
        str = str + "title: \(title)" + "pubDate: \(pubDate)" + "episode:\(episodes.count)"
        
        for episode in episodes {
            str = str + "======================="
            str = str + "title:\(episode.title)" + "description:\(episode.description)" + "pubDate:\(episode.pubDate)" + "link:\(episode.link?.absoluteString ?? "" + "guid: \(episode.guid)")"
            str = str + "======================="
        }
        
        return str
    }
    
    lazy var session: URLSession = {
       
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        return session
    }()
}


class Episode {
    var title = ""
    var description = ""
    var pubDate = ""
    var link: URL?
    var guid: String?
    var session: URLSession?
    
    func read(MP3Link: String) {
        
        
        findMP3LinkIn(urlStr: MP3Link) { (fileSize: String?, linkUrlStr: String?) in
            
            if let linkUrlStr = linkUrlStr {
                self.link = URL(string:linkUrlStr)
            }
            
        }
 
    }
    
    func findMP3LinkIn(urlStr: String, completion: @escaping (_ fileSize: String?, _ linkUrlStr: String?) -> ()) {
        
        guard let url = URL(string: urlStr),
            let data = try? Data.init(contentsOf: url),
            let html = String.init(data: data, encoding: .utf8),
            let doc = HTML(html: html, encoding: .utf8) else {
                
                completion(nil, nil)
                return
        }
        
        // Search for nodes by CSS
        for link in doc.css("a, link") {
            if let link = link["href"],
                link.contains(".mp3"),
                let linkUrl = URL(string: link),
                let newURL = linkUrl.removeArgument() {
                
                
                // create a request, get the file size
                var request = URLRequest(url: newURL)
                request.httpMethod = "HEAD"

                session!.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                    
                    //                    print("expectedLength:\(response?.expectedContentLength)")
                    //                    print("mimetype:\(response?.mimeType)")
                    
                    if let response = response {
                        completion("\(response.expectedContentLength)", newURL.absoluteString)
                    }
                    
                    }.resume()
            }
        }
        
        completion(nil, nil)
    }
    
}

