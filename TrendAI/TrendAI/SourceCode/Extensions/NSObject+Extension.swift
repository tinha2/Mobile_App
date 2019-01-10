//
//  NSObject+Extension.swift
//  eschool
//
//  Created by nguyen.manh.tuanb on 8/7/18.
//  Copyright © 2018 nguyen.manh.tuanb. All rights reserved.
//

import Foundation

extension NSObject {
    class var className: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    var className: String {
        return String(describing: type(of: self)).components(separatedBy: ".").last!
    }
}
