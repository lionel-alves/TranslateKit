//
//  Definition.swift
//  TranslateKit
//
//  Created by Lionel on 1/23/16.
//  Copyright © 2016 weTranslate. All rights reserved.
//

import Foundation

public struct SlangDefinition {

    // MARK: - Properties

    public let id: Double
    public let definition: String
    public let example: String
    public let thumbsUp: Double
    public let thumbsDown: Double
}


extension SlangDefinition: DictionaryDeserializable, DictionarySerializable {

    public init?(dictionary: JSONDictionary) {

        guard let id = dictionary["defid"] as? Double,
            let definition = dictionary["definition"] as? String,
            let example = dictionary["example"] as? String,
            let thumbsUp = dictionary["thumbs_up"] as? Double,
            let thumbsDown = dictionary["thumbs_down"] as? Double else { return nil }

        self.id = id
        self.definition = definition
        self.example = example
        self.thumbsUp = thumbsUp
        self.thumbsDown = thumbsDown
    }

    public var dictionary: JSONDictionary {
        return [
            "defid": id as AnyObject,
            "definition": definition as AnyObject,
            "example": example as AnyObject,
            "thumbs_up": thumbsUp as AnyObject,
            "thumbs_down": thumbsDown as AnyObject,
        ]
    }
}
