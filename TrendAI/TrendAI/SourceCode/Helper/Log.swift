//
//  Log.swift
//  eschool
//
//  Created by nguyen.manh.tuanb on 8/15/18.
//  Copyright © 2018 nguyen.manh.tuanb. All rights reserved.
//

import Foundation

struct Log {
    static func debug(message: String, function: String = #function) {
        #if !NDEBUG
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let date = formatter.string(from: NSDate() as Date)
        print("\(date) Func: \(function) : \(message)")
        #endif
    }
}
