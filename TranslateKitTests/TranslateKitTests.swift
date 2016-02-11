//
//  TranslateKitTests.swift
//  TranslateKitTests
//
//  Created by Lionel on 1/23/16.
//  Copyright © 2016 weTranslate. All rights reserved.
//

import XCTest
import Alamofire
@testable import TranslateKit

class TranslateKitTests: XCTestCase {

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
        XCTAssert(true)
    }

    func testTranslateWord() {
        // TODO: use DVR for testing instead of a real api call
        let expectation = expectationWithDescription("Network")
        let client = Client()

        let expectedDefinition = "what you say when your talking casually with friends and your mom walks in the room"
        let expectedExample = "What the hell(mom enters)-o mom."

        client.translate(word: "hello") { definitions in
            if let definitions = definitions {
                XCTAssertEqual(definitions.first?.example, expectedExample)
                XCTAssertEqual(definitions.first?.definition, expectedDefinition)
            } else {
                XCTFail()
            }
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1, handler: nil)
    }
}
