//
//  Translation.swift
//  TranslateKit
//
//  Created by Jennifer on 13/02/2016.
//  Copyright © 2016 weTranslate. All rights reserved.
//

import UIKit

public struct Translation: DictionaryDeserializable, DictionarySerializable {

    public let meanings: [Meaning]
    public let additionalMeanings: [Meaning]
    public let compoundMeanings: [Meaning]

    public init?(dictionary:JSONDictionary) {
        guard let principalesDictionary = dictionary["PrincipalMeanings"] as? [JSONDictionary] else { return nil }

        let meanings = principalesDictionary.flatMap { Meaning(dictionary: $0) }
        guard meanings.count > 0 else { return nil }

        self.meanings = meanings
        self.additionalMeanings = (dictionary["AdditionalMeanings"] as? [JSONDictionary])?.flatMap { Meaning(dictionary: $0) } ?? []
        self.compoundMeanings = (dictionary["CompoundMeanings"] as? [JSONDictionary])?.flatMap { Meaning(dictionary: $0) } ?? []
    }

    public init?(webserviceDictionary:JSONDictionary) {
        guard let termDictionary = webserviceDictionary["term0"] as? JSONDictionary else { return nil }

        let meanings = Translation.meanings(fromWebDictionary: termDictionary["PrincipalTranslations"] as? JSONDictionary)
        guard meanings.count > 0 else { return nil }

        self.meanings = meanings
        self.additionalMeanings = Translation.meanings(fromWebDictionary: termDictionary["AdditionalTranslations"] as? JSONDictionary)
        self.compoundMeanings = Translation.meanings(fromWebDictionary: webserviceDictionary["original"]?["Compounds"] as? JSONDictionary)
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

    public var dictionary: JSONDictionary {

        let meaningsDictionary = meanings.map { $0.dictionary }
        let additionalMeaningsDictionary = additionalMeanings.map { $0.dictionary }
        let compoundMeaningsDictionary = compoundMeanings.map { $0.dictionary }

        return [
            "PrincipalMeanings" : meaningsDictionary,
            "AdditionalMeanings" : additionalMeaningsDictionary,
            "CompoundMeanings" : compoundMeaningsDictionary
        ]
    }
}
