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
    
    // Urban dictionary
    func testDefineWord() {
        
        let dvr = Session(cassetteName: "api-DefineWord", backingSession: Client.defaultSession)
        let expectation = self.expectation(description: "Network")
        let client = Client(wordReferenceApiKey: "api_key", URLSession:dvr)

        client.define(slang: "hello") { result in
            guard case .success(let definitions) = result else {
                XCTFail("Failure.")
                return
            }

            XCTAssertEqual(definitions.first?.definition, "what you say when your talking casually with friends and your mom walks in the room")
            XCTAssertEqual(definitions.first?.example, "What the hell(mom enters)-o mom.")
            XCTAssertEqual(definitions.first?.thumbsUp, 2790)
            XCTAssertEqual(definitions.first?.thumbsDown, 806)

            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // Word Reference
    func testTranslateWord() {
        
        let dvr = Session(cassetteName: "api-TranslateWord", backingSession: Client.defaultSession)
        let expectation = self.expectation(description: "Network")
        let client = Client(wordReferenceApiKey: "api_key", URLSession:dvr)
        
        client.translate(word: "arm", from: .English, to: .French) { result in
            guard case .success(let t) = result,
                let translation = t else {
                    XCTFail("Failure.")
                    return
            }

            XCTAssertEqual(translation.searchText, "arm")
            XCTAssertEqual(translation.fromLanguage, Language.English)
            XCTAssertEqual(translation.toLanguage, Language.French)

            // Principal Translation
            XCTAssertEqual(translation.meanings.first?.translatedWords.first?.term, "bras")
            XCTAssertEqual(translation.meanings.first?.translatedWords.first?.pos, "nm")
            XCTAssertEqual(translation.meanings.first?.translatedWords.first?.sense, "corps")

            XCTAssertEqual(translation.meanings.first?.originalWord.term, "arm")
            XCTAssertEqual(translation.meanings.first?.originalWord.pos, "n")
            XCTAssertEqual(translation.meanings.first?.originalWord.sense, "upper limb")

            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testTranslateWordNotFound() {

        let dvr = Session(cassetteName: "api-TranslateWordNotFound", backingSession: Client.defaultSession)
        let expectation = self.expectation(description: "Network")
        let client = Client(wordReferenceApiKey: "API_KEY", URLSession: dvr)

        client.translate(word: "kjbkkfsubfskubksfbksfbsf", from: .English, to: .French) { result in
            guard case .success(let translation) = result, translation == nil else {
                XCTFail("Failure.")
                return
            }
            XCTAssertTrue(true)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}
