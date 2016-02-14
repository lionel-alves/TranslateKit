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
                XCTAssertEqual(translation.additionalMeanings.first?.translatedWords.first?.term, "manche, bras")
                XCTAssertEqual(translation.additionalMeanings.first?.translatedWords.first?.pos, "nm")
                XCTAssertEqual(translation.additionalMeanings.first?.translatedWords.first?.sense, "machine")
                
                XCTAssertEqual(translation.additionalMeanings.first?.originalWord.term, "arm")
                XCTAssertEqual(translation.additionalMeanings.first?.originalWord.pos, "n")
                XCTAssertEqual(translation.additionalMeanings.first?.originalWord.sense, "machine: arm like lever")
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
                XCTAssertEqual(translation.compoundMeanings.first?.translatedWords.first?.term, "aéronavale")
                XCTAssertEqual(translation.compoundMeanings.first?.translatedWords.first?.pos, "nf")
                XCTAssertEqual(translation.compoundMeanings.first?.translatedWords.first?.sense, "")
                
                // Original Term
                XCTAssertEqual(translation.compoundMeanings.first?.originalWord.term, "air arm")
                XCTAssertEqual(translation.compoundMeanings.first?.originalWord.pos, "")
                XCTAssertEqual(translation.compoundMeanings.first?.originalWord.sense, "")
            }
            else {
                XCTFail("Failure.")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1, handler: nil)
    }
}