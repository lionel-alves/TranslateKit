//
//  Translation.swift
//  TranslateKit
//
//  Created by Jennifer on 13/02/2016.
//  Copyright © 2016 weTranslate. All rights reserved.
//

import UIKit

public struct Translation: Equatable {

    // MARK: - Properties

    public let fromLanguage: Language
    public let toLanguage: Language
    public let searchText: String

    public let meanings: [Meaning]


    // MARK: - Initializer

    init?(webserviceDictionary: JSONDictionary, searchText: String, from: Language, to: Language) {
        guard let termDictionary = webserviceDictionary["term0"] as? JSONDictionary else { return nil }

        self.fromLanguage = from
        self.toLanguage = to
        self.searchText = searchText

        var meanings = Translation.meanings(fromWebDictionary: termDictionary["PrincipalTranslations"] as? JSONDictionary)
        meanings.appendContentsOf(Translation.meanings(fromWebDictionary: termDictionary["AdditionalTranslations"] as? JSONDictionary))
        meanings.appendContentsOf(Translation.meanings(fromWebDictionary: webserviceDictionary["original"]?["Compounds"] as? JSONDictionary))

        guard meanings.count > 0 else { return nil }
        self.meanings = meanings
    }


    // MARK: - Private

    static private func meanings(fromWebDictionary dictionary: JSONDictionary?) -> [Meaning] {
        guard let meaningsDictionary = dictionary else { return [] }

        let sortedDictionary = meaningsDictionary.sort({ $0.0 < $1.0 })
        let meanings:[Meaning] = sortedDictionary.flatMap {
            guard let dictionary = $0.1 as? JSONDictionary else { return nil }
            return Meaning(webserviceDictionary: dictionary)
        }

        return meanings
    }
}


extension Translation: Hashable {
    public var hashValue: Int {
        return fromLanguage.hashValue ^ toLanguage.hashValue ^ searchText.hashValue
    }
}


public func ==(lhs: Translation, rhs: Translation) -> Bool {
    return lhs.hashValue == rhs.hashValue
}


extension Translation: DictionaryDeserializable, DictionarySerializable {

    public init?(dictionary: JSONDictionary) {
        guard let fromLanguageRawValue = dictionary["FromLanguage"] as? String,
                fromLanguage = Language(rawValue: fromLanguageRawValue),
                toLanguageRawValue = dictionary["ToLanguage"] as? String,
                toLanguage = Language(rawValue: toLanguageRawValue),
                searchText = dictionary["SearchText"] as? String,
                meaningsDictionary = dictionary["Meanings"] as? [JSONDictionary] else { return nil }

        self.fromLanguage = fromLanguage
        self.toLanguage = toLanguage
        self.searchText = searchText

        let meanings = meaningsDictionary.flatMap { Meaning(dictionary: $0) }
        guard meanings.count > 0 else { return nil }

        self.meanings = meanings
    }

    public var dictionary: JSONDictionary {

        let meaningsDictionary = meanings.map { $0.dictionary }

        return [
            "FromLanguage" : fromLanguage.rawValue,
            "ToLanguage" : toLanguage.rawValue,
            "SearchText" : searchText,
            "Meanings" : meaningsDictionary,
        ]
    }
}
