//
//  Meaning.swift
//  TranslateKit
//
//  Created by Jennifer on 13/02/2016.
//  Copyright © 2016 weTranslate. All rights reserved.
//

import Foundation

public struct Meaning: DictionaryDeserializable, DictionarySerializable {
    
    public let originalWord: Word
    public let translatedWords: [Word]
    
    enum OrdinalNumber: String {
        case OriginalTerm
        case FirstTranslation
        case SecondTranslation
        case ThirdTranslation
        case FourthTranslation
        case FifthTranslation
        case SixthTranslation
        case SeventhTranslation
        case EighthTranslation
        case NinthTranslation
        case TenthTranslation
        
        var priority: Int {
            switch self {
            case OriginalTerm:          return 0
            case FirstTranslation:      return 1
            case SecondTranslation:     return 2
            case ThirdTranslation:      return 3
            case FourthTranslation:     return 4
            case FifthTranslation:      return 5
            case SixthTranslation:      return 6
            case SeventhTranslation:    return 7
            case EighthTranslation:     return 8
            case NinthTranslation:      return 9
            case TenthTranslation:      return 10
            }
        }
    }
    
    public init?(dictionary: JSONDictionary) {
        
        guard let originalWordDictionary = dictionary["OriginalTerm"] as? JSONDictionary,
            originalWord = Word(dictionary: originalWordDictionary) else { return nil }
        
        self.originalWord = originalWord
        
        let sortedDictionaries = dictionary.sort {
            Meaning.OrdinalNumber(rawValue: $0.0)?.priority < Meaning.OrdinalNumber(rawValue: $1.0)?.priority
        }
        
        self.translatedWords = sortedDictionaries.flatMap {
            guard let dictionary = $0.1 as? JSONDictionary where $0.0 != "OriginalTerm" else { return nil }
            return Word(dictionary: dictionary)
        }
    }
    
    public var dictionary: JSONDictionary {
        
        let translatedWordsDictionary = translatedWords.map({ $0.dictionary })
        
        return ["originalWord": originalWord.dictionary,
            "translatedWords" : translatedWordsDictionary
        ]
    }
}
