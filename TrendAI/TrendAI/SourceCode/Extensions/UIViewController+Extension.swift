//
//  UIViewController+Extension.swift
//  eschool
//
//  Created by nguyen.huu.hoang on 8/15/18.
//  Copyright © 2018 nguyen.manh.tuanb. All rights reserved.
//

import UIKit

//Get Xib file
func getXibViewController<T: UIViewController>(_ viewControllerClassName: T.Type) -> T? {
    let name = String(describing: T.self)
    if Bundle.main.path(forResource: name, ofType: "nib") != nil ||
        Bundle.main.path(forResource: name, ofType: "xib") != nil {
        return T(nibName: name, bundle: nil)
    }
    return nil
}

extension UIViewController {
    class func getXibVC() -> Self? {
        return getXibViewController(self)
    }
}
