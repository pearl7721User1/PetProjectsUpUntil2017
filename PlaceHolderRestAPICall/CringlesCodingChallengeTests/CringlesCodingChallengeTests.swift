//
//  CringlesCodingChallengeTests.swift
//  CringlesCodingChallengeTests
//
//  Created by SeoGiwon on 4/14/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import XCTest
@testable import CringlesCodingChallenge

class CringlesCodingChallengeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFetchCommentsClient() {
        
        // see if fetching/parsing json works
        let mockSession = URLSessionMock(jsonDict: [["postId": 1,
                                                     "id": 1,
                                                     "name": "id labore ex et quam laborum",
                                                     "email": "Eliseo@gardner.biz",
                                                     "body": "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium"],
                                                    ["postId": 1,
                                                     "id": 3,
                                                     "name": "odio adipisci rerum aut animi",
                                                     "email": "Nikita@garfield.biz",
                                                     "body": "quia molestiae reprehenderit quasi aspernatur\naut expedita occaecati aliquam eveniet laudantium\nomnis quibusdam delectus saepe quia accusamus maiores nam est\ncum et ducimus et vero voluptates excepturi deleniti ratione"],
                                                    ["postId": 2,
                                                     "id": 2,
                                                     "name": "quo vero reiciendis velit similique earum",
                                                     "email": "Jayne_Kuhic@sydney.com",
                                                     "body": "est natus enim nihil est dolore omnis voluptatem numquam\net omnis occaecati quod ullam at\nvoluptatem error expedita pariatur\nnihil sint nostrum voluptatem reiciendis et"]
                                                    ])!
        
        let client = CommentsClient(session: mockSession)
        
        let responseExpectation = expectation(description: "APICall")
        client.fetchComments { (error) -> (Void) in
            responseExpectation.fulfill()
            XCTAssertNil(error)
        }

        waitForExpectations(timeout: 5, handler:nil)
        
        // see if fetchComments function works as it is intended to
        XCTAssertEqual(client.commentList[0].email, "Eliseo@gardner.biz")
        XCTAssertEqual(client.commentList[1].email, "Nikita@garfield.biz")
        XCTAssertEqual(client.commentList[2].email, "Jayne_Kuhic@sydney.com")
        XCTAssertEqual(client.commentList[0].id, 1)
        XCTAssertEqual(client.commentList[1].id, 3)
        XCTAssertEqual(client.commentList[2].id, 2)
        XCTAssertEqual(client.commentList[0].postID, 1)
        XCTAssertEqual(client.commentList[1].postID, 1)
        XCTAssertEqual(client.commentList[2].postID, 2)
        
        // see if idDescending sorting works
        let idDescending = IDDescendingViewController()
        idDescending.prepare(ForCommentList: client.commentList)
        
        XCTAssertEqual(idDescending.commentList![0].id, 3)
        XCTAssertEqual(idDescending.commentList![1].id, 2)
        XCTAssertEqual(idDescending.commentList![2].id, 1)

        // see if emailAlphabetical sorting works
        let emailAlphabetical = EmailAlphabeticViewController()
        emailAlphabetical.prepare(ForCommentList: client.commentList)
        
        XCTAssertEqual(emailAlphabetical.commentList![0].email, "Eliseo@gardner.biz")
        XCTAssertEqual(emailAlphabetical.commentList![1].email, "Jayne_Kuhic@sydney.com")
        XCTAssertEqual(emailAlphabetical.commentList![2].email, "Nikita@garfield.biz")
        
        // see if evenPost filtering works
        let evenPostOnly = EvenPostIDViewController()
        evenPostOnly.prepare(ForCommentList: client.commentList)
        
        XCTAssertEqual(evenPostOnly.commentList!.count, 1)
        XCTAssertEqual(evenPostOnly.commentList![0].postID, 2)
        
    }
    
}
