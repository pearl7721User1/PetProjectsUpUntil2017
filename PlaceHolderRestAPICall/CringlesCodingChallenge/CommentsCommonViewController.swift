//
//  CommentsCommonViewController.swift
//  CringlesCodingChallenge
//
//  Created by SeoGiwon on 4/14/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class CommentsCommonViewController: UITableViewController {

    // defines tag numbers for cell components(UILabels)
    enum CommentCellComponent: Int {
        case id = 1
        case postId
        case name
        case email
        case body
    }
    
    // defines cell reuseIdentifiers
    enum CommentCellType: String {
        case CommentCell
    }
    
    // defines table view datasource model; it's managed by main thread for UI is involved.
    var commentList: [Comment]? {
        didSet {
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        commentCommonInit()
        
        // to not having status bar get in the way
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    func notificationReceiver(_ notification: Notification) {
        
        guard let infoDict = notification.userInfo as? [String: Any],
            let list = infoDict["List"] as? [Comment]
            else { fatalError("Something went wrong with 'CommentsFed' notification delivery") }
        
        prepare(ForCommentList: list)
    }
    
    // for overriding only - preparing meaning sorting mostly for display
    func prepare(ForCommentList list:[Comment]) {
        
    }
    
    deinit {
        commentCommonDeinit()
    }
    
}

extension CommentsCommonViewController: CommentsClientProtocol {
    
    // defines notification adding/removing that requires for CommentsCommonViewController subclasses to import the tableview data source model as soon as CommentsClient fetches it.
    func commentCommonInit() {
        
        let notification: CustomNotification = .CommentsFed
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceiver(_:)), name: NSNotification.Name(rawValue: notification.rawValue), object: nil)
    }
    
    func commentCommonDeinit() {
        let notification: CustomNotification = .CommentsFed
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: notification.rawValue), object: nil)
    }
}
