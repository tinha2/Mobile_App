//
//  eNum.swift
//  SohaPay
//
//  Created by Chung BD on 5/11/16.
//  Copyright © 2016 Tran Anh. All rights reserved.
//

import Foundation

enum eResponseCode: Int {
    case error              = 9999
    case networkConnection  = 9991
    case success            = 1
    case fail               = -1
    case expire             = -2
    case notTakeToken       = -3
    case notSuccess         = -4
    case wrongInProcessingData         = -5
}
