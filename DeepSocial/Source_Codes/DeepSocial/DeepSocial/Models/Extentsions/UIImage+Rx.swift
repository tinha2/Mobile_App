//
//  UIImage+Rx.swift
//  RxExtensions
//
//  Created by Hoan Pham on 8/2/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//

import UIKit

import RxSwift


extension UIImageView {
    public func rx_setImageFromURL(_ url: URL, placeHolder: UIImage? = nil) -> Observable<UIImage> {
        if let placeHolder = placeHolder {
            self.image = placeHolder
        }
        
        let obs = URLSession.shared
            .rx.data(request: URLRequest(url: url))
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .flatMap { x -> Observable<UIImage> in
                if let image = UIImage(data: x) {
                    return Observable.just(image)
                }
                return Observable.error(DLErrors.couldNotParseImageFromData)
            }
        
        return obs
    }
}
