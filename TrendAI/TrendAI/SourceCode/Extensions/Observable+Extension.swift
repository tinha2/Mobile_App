//
//  Observable+Extension.swift
//  eschool
//
//  Created by nguyen.manh.tuanb on 8/7/18.
//  Copyright © 2018 nguyen.manh.tuanb. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Observable {
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    func catchErrorJustComplete() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { _ in
            return Driver.empty()
        }
    }
}

extension Driver {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
    
    /**
     Invokes an action for each event in the observable sequence,
     and propagates all observer messages through the result sequence.
     
     - parameter variable: Target variable for sequence elements.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func `do`(_ variable: Variable<E>) -> SharedSequence<SharingStrategy, E> {
        return `do`(onNext: { e in
            variable.value = e
        })
    }
    
    /**
     Invokes an action for each event in the observable sequence,
     and propagates all observer messages through the result sequence.
     
     - parameter variable: Target variable for sequence elements.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func `do`(_ variable: Variable<E?>) -> SharedSequence<SharingStrategy, E> {
        return `do`(onNext: { e in
            variable.value = e
        })
    }
}
