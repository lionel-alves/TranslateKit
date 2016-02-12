//
//  TranslateKitTests.swift
//  TranslateKitTests
//
//  Created by Lionel on 1/23/16.
//  Copyright © 2016 weTranslate. All rights reserved.
//

import XCTest
@testable import TranslateKit

class TranslateKitTests: XCTestCase {

    func testDefineWord() {
        // TODO: use DVR for testing instead of a real api call
        let expectation = expectationWithDescription("Network")
        let client = Client()

        let expectedDefinition = "what you say when your talking casually with friends and your mom walks in the room"
        let expectedExample = "What the hell(mom enters)-o mom."

        client.define(word: "hello") { definitions in
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
