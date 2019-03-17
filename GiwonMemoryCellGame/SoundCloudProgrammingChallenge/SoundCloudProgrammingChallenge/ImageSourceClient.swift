//
//  ImageSourceClient.swift
//  SoundCloudProgrammingChallenge
//
import UIKit

// types that defines errors that might occur
enum ImageSourceModelError: Error {
    case urlSessionError
    case jsonParsingError
    case jsonInvalidError
    case imgDownloadError
}

// This class represents the client to take care of the network needs.
class ImageSourceClient {
    
    // url session that may run as a mock
    var session: MGURLSession = URLSession.shared
    
    // api end point to download images for memory cells
    let apiEndPoint = "http://api.soundcloud.com/playlists/79670980?client_id=aa45989bb0c262788e2d11f1ea041b65"
    
    // when images are set, a notification is sent to the MemoryCellViewController object to populate the memory cells that it manages
    var artWorks: [UIImage]? {
        didSet {
            
            guard let images = artWorks else { return }
            
            // get a distribution information so that memory cell images are arranged in random order
            let imageIndexes = self.getUniqueRandomNumbers(ofSize: memoryCellsTotal).map {$0 % memoryCellsTotal/2}
            let msg = ["ArtWorks": images, "Indexes": imageIndexes] as [String : Any]
            
            // send notification
            let notification: CustomNotification = .ImageDownloadCompleted
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: notification.rawValue), object: nil, userInfo: msg)
        }
    }
    
    init(session: MGURLSession = URLSession.shared) {
        self.session = session
    }
    
    // In this function, it requests json data; parse it; pull image urls; download them. If an error occurs during the process, it immediately returns with the error object.
    func fetchImageSource(_ completion: @escaping (ImageSourceModelError?) -> (Void)) {
        
        guard let url = URL(string: apiEndPoint) else { fatalError("apiEndPoint is not valid") }
        let urlRequest = URLRequest(url: url)
        
        let task = session.dataTask(with: urlRequest, completionHandler:
            {(data: Data?, response: URLResponse?, error: Error?) in
                
                // if no any data is delivered, it returns
                guard let theData = data, error == nil
                else {
                    completion(ImageSourceModelError.urlSessionError)
                    return
                }
                
                // if json parsing fails for some reasons, it returns
                guard let json = try? JSONSerialization.jsonObject(with: theData),
                    let dict = json as? [String: Any]
                else {
                    completion(ImageSourceModelError.jsonParsingError)
                    return
                }

                // if it can't pull urls from the json dictionary, it returns
                guard let urls = self.pullUrls(from: dict) else {
                    completion(ImageSourceModelError.jsonInvalidError)
                    return
                }
                
                // if it can't download any single image for some reasons, it returns
                guard let images = self.pullImages(from: urls) else {
                    completion(ImageSourceModelError.imgDownloadError)
                    return
                }
                
                // if all processes are successful, update model
                self.artWorks = images
                
                completion(nil)
                return
        })
        
        task.resume()
    }
    
    // pull urls from the json dictionary
    func pullUrls(from dict:[String: Any]) -> [String]? {
        
        var urls = [String]()
        
        guard let tracks = dict["tracks"] as? [Any],
            tracks.count >= memoryCellsTotal/2
        else { return nil }
        
        
        for idx in 0...memoryCellsTotal/2-1 {
            
            guard let tracksDict = tracks[idx] as? [String: Any],
                let artWorkUrl = tracksDict["artwork_url"] as? String else { return nil }
            
            urls.append(artWorkUrl)
        }
        
        return urls
    }
    
    // download images from the given urls
    func pullImages(from urls: [String]) -> [UIImage]? {
        
        var images = [UIImage]()
        
        for urlStr in urls {
            guard let url = URL(string: urlStr),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data)
            else { return nil }
            
            images.append(image)
        }
        
        return images
    }
    
    // This function generates integer permutation that ranges from 0 to the given size. Each integer is unique to each other. The memory cell images are distributed to each memory cell at a designated index.
    func getUniqueRandomNumbers(ofSize size: Int) -> [Int] {
        
        var array = [Int]()
        
        while (array.count < size) {
            
            let newNum = Int(arc4random()) % size
            if !array.contains(newNum) {
                array.append(newNum)
            }
        }
        
        return array
    }
}


