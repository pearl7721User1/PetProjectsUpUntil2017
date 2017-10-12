//
//  IDDescendingViewController.swift
//  CringlesCodingChallenge
//
//  Created by SeoGiwon on 4/14/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class IDDescendingViewController: CommentsCommonViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if Comments are already set in the CommentsClient instance before this view controller is created, fetch Comments from it manually; this happens because viewControllers that establish TabbarViewController are lazily created except the leftmost one.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        prepare(ForCommentList: appDelegate.commentsClient.commentList)
    }
    
    // this function is called as soon as the CommentsClient instance fetches Comments, or is called manually when this view controller is created
    override func prepare(ForCommentList list: [Comment]) {
        
        // sort it as id descending
        self.commentList = list.sorted(by: { (leftValue, rightValue) -> Bool in
            return leftValue.id > rightValue.id
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.commentList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentCellType.CommentCell.rawValue, for: indexPath)
     
        if let comment = self.commentList?[indexPath.row] {
            configure(at: cell, with: comment)
        }
        
        return cell
    }

    private func configure(at cell: UITableViewCell, with comment: Comment) {
        
        
        guard let idLB = cell.viewWithTag(CommentCellComponent.id.rawValue) as? UILabel,
            let postIdLB = cell.viewWithTag(CommentCellComponent.postId.rawValue) as? UILabel,
            let nameLB = cell.viewWithTag(CommentCellComponent.name.rawValue) as? UILabel,
            let emailLB = cell.viewWithTag(CommentCellComponent.email.rawValue) as? UILabel,
            let bodyLB = cell.viewWithTag(CommentCellComponent.body.rawValue) as? UILabel else { fatalError() }
 
      
        idLB.text = "\(comment.id)"
        postIdLB.text = "\(comment.postID)"
        nameLB.text = comment.name
        emailLB.text = comment.email
        bodyLB.text = comment.body
    }
    
}
