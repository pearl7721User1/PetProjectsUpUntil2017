//
//  MyWebImageTests.swift
//  MyWebImageTests
//
//  Created by SeoGiwon on 25/05/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import XCTest
@testable import MyWebImage

class MyWebImageTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSaveAndLoad() {

        let jpgImg = UIImage(named: "1.jpeg")
        let pngImg = UIImage(named: "apple_raw.png")
        
        XCTAssertTrue(GiwonWebImage.sharedInstance.save(image: jpgImg!, urlStr: "1.jpeg"))
        XCTAssertTrue(GiwonWebImage.sharedInstance.save(image: pngImg!, urlStr: "2.png"))
        
        GiwonWebImage.sharedInstance.image(from: "1.jpeg") { (image: UIImage?) in
            
            XCTAssertNotNil(image)
            
        }
    }
    
    func testImageDownloading() {
        
        let urlString = "http://www.pearl7721giwon.com/SampleImages/Kitchen_THN.jpg"
        let myWebImage = GiwonWebImage.sharedInstance
        
        let asyncExpectation = expectation(description: "All Transactions Expectation")
        
        myWebImage.image(from: urlString) { (image: UIImage?) in
            
            asyncExpectation.fulfill()
            
            // succeeded to get the image
            XCTAssertNotNil(image)
            
            // check if the app's cache holds the image at this point
            XCTAssertNotNil(myWebImage.appCache.object(forKey: (urlString.keyFileString() ?? "") as NSString))
        }
        
        self.waitForExpectations(timeout: 5) { (error: Error?) -> Void in
            if let error = error {
                XCTFail("Wait for \(asyncExpectation.description): \(error)")
            }
        }
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {

        }
    }
    
}
