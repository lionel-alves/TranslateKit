//
//  TranslateKitTests.swift
//  TranslateKitTests
//
//  Created by Lionel on 1/23/16.
//  Copyright © 2016 weTranslate. All rights reserved.
//

import XCTest
import DVR
@testable import TranslateKit

class TranslateKitTests: XCTestCase {
    
    func testDefineWord() {
        
        let dvr = Session(cassetteName: "api-DefineWord", backingSession: Client.defaultSession)
        let expectation = expectationWithDescription("Network")
        let client = Client(URLSession:dvr)

        client.define(slang: "hello") { definitions in
            if let definitions = definitions {
                XCTAssertEqual(definitions.first?.definition, "what you say when your talking casually with friends and your mom walks in the room")
                XCTAssertEqual(definitions.first?.example, "What the hell(mom enters)-o mom.")
                XCTAssertEqual(definitions.first?.thumbsUp, 2790)
                XCTAssertEqual(definitions.first?.thumbsDown, 806)
            }
            else {
                XCTFail("Failure.")
            }

            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1, handler: nil)
    }
}
