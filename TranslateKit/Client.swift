//
//  Client.swift
//  TranslateKit
//
//  Created by Lionel on 1/23/16.
//  Copyright © 2016 weTranslate. All rights reserved.
//

import Foundation
import Alamofire

public typealias JSONDictionary = [String: AnyObject]

public class Client {

    public let baseURL = "http://api.urbandictionary.com/v0"

    public func define(word word: String, completion: [Definition]? -> Void) {
        Alamofire.request(.GET, "\(baseURL)/define", parameters: ["term": word])
            .responseJSON { response in

                if let JSON = response.result.value as? JSONDictionary,
                    list = JSON["list"] as? [JSONDictionary] {
                        let definitions = list.flatMap { Definition(dictionary: $0) }
                        completion(definitions)
                } else {
                    completion(nil)
                }
        }
    }
}
