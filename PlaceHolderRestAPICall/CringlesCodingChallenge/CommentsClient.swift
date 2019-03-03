//
//  CommentsClient.swift
//  CringlesCodingChallenge
//
//  Created by SeoGiwon on 4/14/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

// types that defines errors that might occur
enum FetchCommentsError: Error {
    case urlSessionError
    case jsonParsingError
    case jsonInvalidError
}

// define notification types that CommentsClient uses
enum CustomNotification: String {
    case CommentsFed
}

// define functions that describe what the notification receiver should do
protocol CommentsClientProtocol {
    func commentCommonInit()
    func commentCommonDeinit()
}

class CommentsClient: Operation {
    
    // url session that may run as a mock
    var session: MightbeMockURLSession = URLSession.shared
    
    // api end point to download json
    let apiEndPoint = "https://jsonplaceholder.typicode.com/comments"

    override func start() {
        
        self.setValue(true, forKey: "isExecuting")
        
        self.fetchComments { (error) -> (Void) in
            
            self.setValue(false, forKey: "isExecuting")
            self.setValue(true, forKey: "isFinished")
        }
        
    }
    
    var commentList = [Comment]() {
        didSet {
            
            // send notification to the CommentsCommonViewController instance that conforms to CommentsClientProtocol
            let notification: CustomNotification = .CommentsFed
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: notification.rawValue), object: nil, userInfo: ["List": commentList])
        }
    }
    
    // initialize it with normal urlsession; but for Unit tests, initialize it with mock urlsession
    init(session: MightbeMockURLSession = URLSession.shared) {
        self.session = session
    }
    
    // fetch comments; return the FetchCommentsError object if an error occurs along the way;
    // if all things are done without errors, 'commentList' is set
    func fetchComments(_ completion: @escaping (FetchCommentsError?) -> (Void)) {
        
        guard let url = URL(string: apiEndPoint) else { fatalError("apiEndPoint is not valid") }
        let urlRequest = URLRequest(url: url)
        
        let task = session.dataTask(with: urlRequest, completionHandler:
            {(data: Data?, response: URLResponse?, error: Error?) in
                
                guard let theData = data, error == nil
                    else {
                        completion(FetchCommentsError.urlSessionError)
                        return
                }
                
                guard let json = try? JSONSerialization.jsonObject(with: theData),
                let commentDictArray = json as? [[String:Any]]
                    else {
                        completion(FetchCommentsError.jsonParsingError)
                        return
                }

                guard let mightBeList = self.createComments(from: commentDictArray) else {
                    completion(FetchCommentsError.jsonInvalidError)
                    return
                }
                
                self.commentList = mightBeList
                
                completion(nil)
                return
                
        })
        
        task.resume()
    }
    
    func createComments(from dictArray:[[String:Any]]) -> [Comment]? {
        
        var list = [Comment]()
        
        for content in dictArray {
            
            guard let postID = content["postId"] as? Int,
                let id = content["id"] as? Int,
                let name = content["name"] as? String,
                let email = content["email"] as? String,
                let body = content["body"] as? String else { return nil }
            
            list.append(Comment(postID: postID, id: id, name: name, email: email, body: body))
        }
        
        return list
    }
}
