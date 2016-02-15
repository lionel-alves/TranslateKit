//
//  Language.swift
//  TranslateKit
//
//  Created by Jennifer on 13/02/2016.
//  Copyright © 2016 weTranslate. All rights reserved.
//

import Foundation

public enum Language: String {
    case French
    case English
    
    public func code() -> String {
        switch self {
        case .French:
            return "fr"
        case .English:
            return "en"
        }
    }
    
    public func name() -> String {
        return String(self)
    }
}
