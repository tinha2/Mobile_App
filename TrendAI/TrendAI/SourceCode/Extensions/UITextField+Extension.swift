//
//  UITextField+Extension.swift
//  eschool
//
//  Created by nguyen.manh.tuanb on 8/16/18.
//  Copyright © 2018 nguyen.manh.tuanb. All rights reserved.
//

import Foundation
import RxSwift

extension UITextField {
    func asObservable() -> Observable<String> {
        return Observable.of(self.rx.controlEvent(.valueChanged).withLatestFrom(self.rx.text.orEmpty.asObservable()),
                             self.rx.text.orEmpty.asObservable()).merge()
    }
    
    @IBInspectable var leftPadding: CGFloat {
        get {
            let leftView = self.leftView?.frame.width ?? 0
            return leftView
        }
        
        set {
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.height))
            self.leftViewMode = .always
            self.leftView = leftView
        }
        
    }
}
