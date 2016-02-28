//
//  Result.swift
//  TranslateKit
//
//  Created by Lionel on 2/28/16.
//  Copyright © 2016 weTranslate. All rights reserved.
//

import Foundation

public enum Result<T> {
    case Success(T)
    case Failure
}
