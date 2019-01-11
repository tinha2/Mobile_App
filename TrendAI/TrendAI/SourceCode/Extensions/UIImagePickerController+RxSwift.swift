//
//  UIImagePickerController+RxSwift.swift
//  Bokkie
//
//  Created by nguyen.manh.tuanb on 1/9/18.
//  Copyright © 2018 Curations. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension UIImagePickerController {
    
    /// Factory method that enables subclasses to implement their own `delegate`.
    /// - returns: Instance of delegate proxy that wraps `delegate`.
    func createRxDelegateProxy() -> RxImagePickerControllerDelegateProxy {
        return RxImagePickerControllerDelegateProxy(parentObject: self)
    }
}

extension Reactive where Base: UIImagePickerController {
    
    /// Reactive wrapper for `delegate`.
    ///
    /// For more information take a look at `DelegateProxyType` protocol documentation.
    var delegate: DelegateProxy<AnyObject, Any> {
        return RxImagePickerControllerDelegateProxy.proxy(for: base)
    }
    
    /// Reactive wrapper for `didFinishPickingMediaWithInfo`.
    var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey: Any]> {
        let proxy = RxImagePickerControllerDelegateProxy.proxy(for: base)
        return proxy.didFinishPickingSubject
    }
    
    /// Reactive wrapper for `didCancel`.
    var didCancel: Observable<Void> {
        let proxy = RxImagePickerControllerDelegateProxy.proxy(for: base)
        return proxy.didCancelPickingSubject
    }
}
