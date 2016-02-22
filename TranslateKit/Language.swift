//
//  Language.swift
//  TranslateKit
//
//  Created by Jennifer on 13/02/2016.
//  Copyright © 2016 weTranslate. All rights reserved.
//

import Foundation

public enum Language: String {

    case Arabic
    case Chinese
    case Czech
    case Dutch
    case English
    case French
    case German
    case Greek
    case Italian
    case Japanese
    case Korean
    case Polish
    case Portuguese
    case Russian
    case Romanian
    case Spanish
    case Swedish
    case Turkish

    
    public func code() -> String {
        switch self {
        case Arabic:
            return "ar"
        case Chinese:
            return "zh"
        case Czech:
            return "cz"
        case Dutch:
            return "nl"
        case English:
            return "en"
        case French:
            return "fr"
        case German:
            return "de"
        case Greek:
            return "gr"
        case Italian:
            return "it"
        case Japanese:
            return "ja"
        case Korean:
            return "ko"
        case Polish:
            return "pl"
        case Portuguese:
            return "pt"
        case Russian:
            return "ru"
        case Romanian:
            return "ro"
        case Spanish:
            return "es"
        case Swedish:
            return "sv"
        case Turkish:
            return "tr"
        }
    }
    
    public func name() -> String {
        return String(self)
    }

    public static func allLanguages() -> [Language] {
        // Dutch, German, Russian, Swedish are not supported
        return [
            .French,
            .Spanish,
            .Italian,
            .Portuguese,
            .Polish,
            .Romanian,
            .Czech,
            .Greek,
            .Turkish,
            .Chinese,
            .Japanese,
            .Korean,
            .Arabic
        ]
    }
}
