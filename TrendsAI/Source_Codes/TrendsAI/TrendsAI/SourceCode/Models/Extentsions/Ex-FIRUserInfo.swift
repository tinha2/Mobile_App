//
//  Ex-FIRUserInfo.swift
//  DeepSocial
//
//  Created by Chung BD on 5/21/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation
import FirebaseAuth

enum AuthProvider:String {
    case password = "password"
    case twitter  = "twitter.com"
    case unknown
}


extension UserInfo {
    var provider:AuthProvider {
        if providerID == AuthProvider.password.rawValue {
            return .password
        }
        
        if providerID == AuthProvider.twitter.rawValue {
            return .twitter
        }
        
        return .unknown
    }
}
