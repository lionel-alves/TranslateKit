//
//  Client.swift
//  TranslateKit
//
//  Created by Lionel on 1/23/16.
//  Copyright © 2016 weTranslate. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String: AnyObject]

public class Client {

    public let URLSession: NSURLSession
    public let baseURL = "http://api.urbandictionary.com/v0"

    public init(URLSession: NSURLSession = defaultSession) {
        self.URLSession = URLSession
    }

    static let defaultSession: NSURLSession = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: configuration)
    }()


    // MARK: - API

    public func define(word word: String, completion: [Definition]? -> Void) {

        guard let URL = NSURL(string: "\(baseURL)/define?term=\(word)") else {
            completion(nil)
            return
        }

        let request = NSMutableURLRequest(URL: URL)

        performRequest(request) { (dictionary: JSONDictionary?) -> Void in
            if let dictionary = dictionary, list = dictionary["list"] as? [JSONDictionary] {
                let definitions = list.flatMap { Definition(dictionary: $0) }
                completion(definitions)
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
}
