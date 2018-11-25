//
//  Subscript_Tests.swift
//  AppDeveloperKit_String Tests
//
//  Created by Scott Carter on 11/25/18.
//  Copyright © 2018 Scott Carter. All rights reserved.
//

import XCTest

class Subscript_Tests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testBasics() {

        var str = "ABCDE"
        str[1] = "😎"
        str[3] = "👩‍🚀"
        
        XCTAssert(str[1] == "😎")
        XCTAssert(str[2] == "C")
        XCTAssert(str[3] == "👩‍🚀")
        XCTAssert(str == "A😎C👩‍🚀E")
        
        
        // Range
        str[1..<4] = "👨‍❤️‍💋‍👨X♡"
        XCTAssert(str[1..<4] == "👨‍❤️‍💋‍👨X♡")
        XCTAssert(str == "A👨‍❤️‍💋‍👨X♡E")
        
        
        // Closed Range
        str[1...4] = "BCDE"
        XCTAssert(str[1...4] == "BCDE")
        XCTAssert(str == "ABCDE")
        
        
        
    }

}
