//
//  Word.swift
//  TranslateKit
//
//  Created by Jennifer on 13/02/2016.
//  Copyright © 2016 weTranslate. All rights reserved.
//

import Foundation

public struct Word: DictionaryDeserializable {
    
    public let term: String
    public let pos: String
    public let sense: String
    public let usage: String?
    
    public init?(dictionary: JSONDictionary) {
        guard let term = dictionary["term"] as? String,
            pos = dictionary["POS"] as? String,
            sense = dictionary["sense"] as? String else { return nil }
        
        self.term = term
        self.pos = pos
        self.sense = sense
        self.usage = dictionary["usage"] as? String
    }

    // FIXME: Implement DictionarySerializable
}
