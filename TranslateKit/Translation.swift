//
//  Translation.swift
//  TranslateKit
//
//  Created by Jennifer on 13/02/2016.
//  Copyright © 2016 weTranslate. All rights reserved.
//

import UIKit

public struct Translation {
    
    public let meanings: [Meaning]
    public let additionalMeanings: [Meaning]
    public let compoundMeanings: [Meaning]
    
    public init?(dictionary:JSONDictionary) {
        guard let termDictionaries = dictionary["term0"] as? JSONDictionary,
            meaningDictionaries = termDictionaries["PrincipalTranslations"] as? JSONDictionary else { return nil }
        let sortedDictionaries = meaningDictionaries.sort({ $0.0 < $1.0 })
        self.meanings = sortedDictionaries.flatMap {
            guard let dictionary = $0.1 as? JSONDictionary else { return nil }
            return Meaning(dictionary: dictionary)
        }
        
        if let additionalMeaningDictionaries = termDictionaries["AdditionalTranslations"] as? JSONDictionary {
            let sortedDictionaries = additionalMeaningDictionaries.sort({ $0.0 < $1.0 })
            self.additionalMeanings = sortedDictionaries.flatMap {
                guard let dictionary = $0.1 as? JSONDictionary else { return nil }
                return Meaning(dictionary: dictionary)
            }
        } else {
            self.additionalMeanings = [];
        }
        
        if let originalDictionaries = dictionary["original"] as? JSONDictionary,
        compoundMeaningDictionaries = originalDictionaries["Compounds"] as? JSONDictionary {
            let sortedDictionaries = compoundMeaningDictionaries.sort({ $0.0 < $1.0 })
            self.compoundMeanings = sortedDictionaries.flatMap {
                guard let dictionary = $0.1 as? JSONDictionary else { return nil }
                return Meaning(dictionary: dictionary)
            }
        }
        else {
            self.compoundMeanings = [];
        }
    }
}
