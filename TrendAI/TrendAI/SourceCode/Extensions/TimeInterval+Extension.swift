//
//  TimeInterval.swift
//  IMuzik
//
//  Created by nguyen.manh.tuanb on 24/12/2018.
//  Copyright © 2018 nguyen.manh.tuanb. All rights reserved.
//

import Foundation

extension TimeInterval {
    func toString(format: NSCalendar.Unit = [.minute, .second]) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = format
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: self) ?? ""
    }
}

