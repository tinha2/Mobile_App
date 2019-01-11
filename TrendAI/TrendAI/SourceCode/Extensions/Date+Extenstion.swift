//
//  Date+Extenstion.swift
//  eschool
//
//  Created by nguyen.manh.tuanb on 8/22/18.
//  Copyright © 2018 nguyen.manh.tuanb. All rights reserved.
//

import Foundation

extension Date {
    func miniSecondsIntervalSince1970() -> Double {
        return self.timeIntervalSince1970 * 1000
    }
    
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
