//
//  ColorTestTests.swift
//  ColorTestTests
//
//  Created by SeoGiwon on 06/06/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import XCTest
@testable import ColorTest

class ColorTestTests: XCTestCase {
    
    func Mask8(x: UInt32) -> UInt32 {
        return x & 0xFF
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        /*
        let value: UInt8 = 0x99
        print(value)
        */
        
        let f: UInt32 = 0xFF
        
        print(f)
        print(f >> 1)
        
        
        let value: UInt32 = 0xCC6699
        
        value & 0xFF
        
        print(UInt8.init(truncatingBitPattern: value))
        print(UInt8.init(truncatingBitPattern: value >> 8))
        print(UInt8.init(truncatingBitPattern: value >> 16))

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
