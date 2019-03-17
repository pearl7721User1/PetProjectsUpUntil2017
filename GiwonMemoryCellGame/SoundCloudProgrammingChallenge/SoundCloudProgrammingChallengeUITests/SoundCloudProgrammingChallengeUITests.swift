//
//  SoundCloudProgrammingChallengeUITests.swift
//  SoundCloudProgrammingChallengeUITests
//

import XCTest

class SoundCloudProgrammingChallengeUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        XCUIApplication().launch()

    }


    func testExample() {
        
        // try off playing the game for a few seconds
        let app = XCUIApplication()
        let element = app.otherElements.containing(.staticText, identifier:"State: ").children(matching: .other).element(boundBy: 0).children(matching: .other).element
        element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.tap()
        element.children(matching: .other).element(boundBy: 3).children(matching: .other).element.tap()
        
        let element2 = element.children(matching: .other).element(boundBy: 4).children(matching: .other).element
        element2.tap()
        element.children(matching: .other).element(boundBy: 10).children(matching: .other).element.tap()
        
        let element3 = element.children(matching: .other).element(boundBy: 7).children(matching: .other).element
        element3.tap()
        element.children(matching: .other).element(boundBy: 13).children(matching: .other).element.tap()
        
        let element4 = element.children(matching: .other).element(boundBy: 11).children(matching: .other).element
        element4.tap()
        element3.tap()
        element.children(matching: .other).element(boundBy: 0).children(matching: .other).element.tap()
        
        let element5 = element.children(matching: .other).element(boundBy: 9).children(matching: .other).element
        element5.tap()
        app.buttons["Reset"].tap()
        element.children(matching: .other).element(boundBy: 2).children(matching: .other).element.tap()
        element5.tap()
        element4.tap()
        element2.tap()
        
    }
    
}


