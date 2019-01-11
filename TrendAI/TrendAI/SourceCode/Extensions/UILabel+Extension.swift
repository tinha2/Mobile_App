//
//  UILabel+Extension.swift
//  eschool
//
//  Created by nguyen.manh.tuanb on 01/11/2018.
//  Copyright © 2018 nguyen.manh.tuanb. All rights reserved.
//

import UIKit

extension UILabel {
    func underLine(text: String) {
        let attributes = text.underLineAtrribute()
        self.attributedText = attributes
    }
}
