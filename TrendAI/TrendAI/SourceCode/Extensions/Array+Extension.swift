//
//  Array+Extension.swift
//  eschool
//
//  Created by nguyen.manh.tuanb on 8/7/18.
//  Copyright © 2018 nguyen.manh.tuanb. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func difference(with other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
