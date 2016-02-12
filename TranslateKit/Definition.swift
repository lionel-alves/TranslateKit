//
//  Definition.swift
//  TranslateKit
//
//  Created by Lionel on 1/23/16.
//  Copyright © 2016 weTranslate. All rights reserved.
//

import Foundation

public struct Definition {

    public let id: Double
    public let definition: String
    public let example: String

    public init?(dictionary: JSONDictionary) {

        guard let id = dictionary["defid"] as? Double,
            definition = dictionary["definition"] as? String,
            example = dictionary["example"] as? String  else { return nil }

        self.id = id
        self.definition = definition
        self.example = example
    }
}
