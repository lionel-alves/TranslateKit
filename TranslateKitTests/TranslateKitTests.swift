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
    
    // Word Reference
    func testTranslateWord() {
        
        let dvr = Session(cassetteName: "api-TranslateWord", backingSession: Client.defaultSession)
        let expectation = expectationWithDescription("Network")
        let client = Client(URLSession:dvr)
        
        client.translate(word: "arm", from: .English, to: .French) { translation in
            if let translation = translation {
                
                // Principal Translation
                XCTAssertEqual(translation.meanings.first?.translatedWords.first?.term, "bras")
                XCTAssertEqual(translation.meanings.first?.translatedWords.first?.pos, "nm")
                XCTAssertEqual(translation.meanings.first?.translatedWords.first?.sense, "corps")
                
                XCTAssertEqual(translation.meanings.first?.originalWord.term, "arm")
                XCTAssertEqual(translation.meanings.first?.originalWord.pos, "n")
                XCTAssertEqual(translation.meanings.first?.originalWord.sense, "upper limb")
            }
            else {
                XCTFail("Failure.")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1, handler: nil)
    }

    func testTranslateWordAdditionalMeaning() {
        
        let dvr = Session(cassetteName: "api-TranslateWord", backingSession: Client.defaultSession)
        let expectation = expectationWithDescription("Network")
        let client = Client(URLSession:dvr)
        
        client.translate(word: "arm", from: .English, to: .French) { translation in
            if let translation = translation {
                // Additional Translation
                XCTAssertEqual(translation.additionalMeanings[1].translatedWords.first?.term, "section, division")
                XCTAssertEqual(translation.additionalMeanings[1].translatedWords.first?.pos, "nf")
                XCTAssertEqual(translation.additionalMeanings[1].translatedWords.first?.sense, "militaire")
                
                XCTAssertEqual(translation.additionalMeanings[1].originalWord.term, "arm")
                XCTAssertEqual(translation.additionalMeanings[1].originalWord.pos, "n")
                XCTAssertEqual(translation.additionalMeanings[1].originalWord.sense, "military: branch")
            }
            else {
                XCTFail("Failure.")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    func testTranslateWordCompoundMeaning() {
        
        let dvr = Session(cassetteName: "api-TranslateWord", backingSession: Client.defaultSession)
        let expectation = expectationWithDescription("Network")
        let client = Client(URLSession:dvr)
        
        client.translate(word: "arm", from: .English, to: .French) { translation in
            if let translation = translation {
                
                // Compound Translation
                XCTAssertEqual(translation.compoundMeanings[1].translatedWords[2].term, "la peau des fesses")
                XCTAssertEqual(translation.compoundMeanings[1].translatedWords[2].pos, "nf")
                XCTAssertEqual(translation.compoundMeanings[1].translatedWords[2].sense, "très familier : coûter")
                
                // Original Term
                XCTAssertEqual(translation.compoundMeanings[1].originalWord.term, "an arm and a leg")
                XCTAssertEqual(translation.compoundMeanings[1].originalWord.pos, "n")
                XCTAssertEqual(translation.compoundMeanings[1].originalWord.sense, "high price, high cost")
            }
            else {
                XCTFail("Failure.")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1, handler: nil)
    }
}
