//
//  Word.swift
//  TranslateKit
//
//  Created by Jennifer on 13/02/2016.
//  Copyright © 2016 weTranslate. All rights reserved.
//

import Foundation

public struct Word {

    // MARK: - Properties

    public let term: String
    public let pos: String
    public let sense: String
    public let usage: String?
}


extension Word: DictionaryDeserializable, DictionarySerializable {
    
    public init?(dictionary: JSONDictionary) {
        guard let term = dictionary["term"] as? String,
            let pos = dictionary["POS"] as? String,
            let sense = dictionary["sense"] as? String, !term.isEmpty && term != "-" else { return nil }

        self.term = term
        self.pos = pos
        self.sense = sense
        self.usage = dictionary["usage"] as? String
    }

    public var dictionary: JSONDictionary {

        var dictionary = [
            "term" : term,
            "POS" : pos,
            "sense" : sense
        ]

        if let usage = usage {
            dictionary["usage"] = usage
        }

        return dictionary as JSONDictionary
    }
}
