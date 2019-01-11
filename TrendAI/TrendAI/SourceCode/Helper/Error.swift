//
//  Error.swift
//  eschool
//
//  Created by nguyen.manh.tuanb on 8/15/18.
//  Copyright © 2018 nguyen.manh.tuanb. All rights reserved.
//

import Foundation

protocol LocalizableError: LocalizedError {
    init?(rawValue: String)
}

public enum CustomError: Error, LocalizedError {
    case error(message: String?)
    case connection
    
    public var errorDescription: String? {
        switch self {
        case .error(let message):
            return message
        case .connection:
            return "Error.Connection".localized()
        }
    }
}

public extension NSError {
    public class func make(message: String, code: Int = 0) -> NSError {
        return NSError(
            domain: "",
            code: code,
            userInfo: [NSLocalizedDescriptionKey: message, NSLocalizedFailureReasonErrorKey: message]
        )
    }
}
