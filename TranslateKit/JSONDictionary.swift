//
//  JSONDictionary.swift
//  TranslateKit
//
//  Created by Lionel on 2/20/16.
//  Copyright © 2016 weTranslate. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String: AnyObject]

public protocol DictionaryDeserializable {
    init?(dictionary: JSONDictionary)
}

public protocol DictionarySerializable {
    var dictionary: JSONDictionary { get }
}
