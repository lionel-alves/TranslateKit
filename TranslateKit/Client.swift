//
//  Client.swift
//  TranslateKit
//
//  Created by Lionel on 1/23/16.
//  Copyright © 2016 weTranslate. All rights reserved.
//

import Foundation

public class Client {
    
    private let URLSession: NSURLSession
    private let urbanDictionaryBaseUrl = "http://api.urbandictionary.com/v0"
    private let wordReferenceBaseUrl: String
    
    public init(wordReferenceApiKey: String, URLSession: NSURLSession = defaultSession) {
        self.wordReferenceBaseUrl = "http://api.wordreference.com/\(wordReferenceApiKey)/json/"
        self.URLSession = URLSession
    }

    static let defaultSession: NSURLSession = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: configuration)
    }()


    // MARK: - API

	// MARK: Urban Dictionary
    public func define(slang word: String, completion: [SlangDefinition]? -> Void) {

        guard let URL = NSURL(string: "\(urbanDictionaryBaseUrl)/define?term=\(word)") else {
            dispatch(result: nil, completion: completion)
            return
        }

        let request = NSMutableURLRequest(URL: URL)

        performRequest(request) { (dictionary: JSONDictionary?) -> Void in
            if let dictionary = dictionary, list = dictionary["list"] as? [JSONDictionary] {
                let definitions = list.flatMap { SlangDefinition(dictionary: $0) }
                self.dispatch(result: definitions, completion: completion)
            }
        }
    }

    // MARK: Word Reference
    public func translate(word word: String, from: Language, to: Language, completion: Translation? -> Void) {
        
        guard let URL = NSURL(string: "\(wordReferenceBaseUrl)/\(from.code())\(to.code())/\(word)") else {
            dispatch(result: nil, completion: completion)
            return
        }
        
        let request = NSMutableURLRequest(URL: URL)
        
        performRequest(request) { (dictionary: JSONDictionary?) -> Void in
            if let translation: Translation = dictionary.flatMap ({ Translation(dictionary: $0) }) {
                self.dispatch(result: translation, completion: completion)
            }
        }
    }

    // MARK: - Private

    private func performRequest(URLRequest: NSURLRequest, completion: JSONDictionary? -> Void) -> NSURLSessionDataTask? {

        let task = URLSession.dataTaskWithRequest(URLRequest) { data, response, error in
            guard let data = data,
                parseData = try? NSJSONSerialization.JSONObjectWithData(data, options: []),
                json = parseData as? JSONDictionary else {
                    completion(nil)
                    return
            }

            completion(json)
        }

        task.resume()
        return task
    }

    private func dispatch<T>(result result: T, completion: T -> Void) {
        dispatch_async(dispatch_get_main_queue()) { completion(result) }
    }
}
