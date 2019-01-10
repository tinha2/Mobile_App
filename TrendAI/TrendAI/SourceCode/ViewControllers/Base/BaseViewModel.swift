//
//  BaseViewModel.swift
//  TrendsAI
//
//  Created by Nguyen Manh Tuan on 1/8/19.
//  Copyright © 2019 Nguyen Manh Tuan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel: NSObject {
    internal var disposeBag = DisposeBag()
    internal let activityIndicator = ActivityIndicator()
    
}
