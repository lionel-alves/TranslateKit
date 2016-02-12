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
        
        let expectedDefinition = "what you say when your talking casually with friends and your mom walks in the room"
        let expectedExample = "What the hell(mom enters)-o mom."
        
        client.define(word: "hello") { definitions in
            if let definitions = definitions {
                XCTAssertEqual(expectedDefinition, definitions.first?.definition)
                XCTAssertEqual(expectedExample, definitions.first?.example)
            }
            else {
                XCTFail("Failure.")
            }

            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1, handler: nil)
    }
}
