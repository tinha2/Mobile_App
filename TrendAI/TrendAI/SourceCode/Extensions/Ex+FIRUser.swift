//
//  Ex+FIRUser.swift
//  TrendAI
//
//  Created by Chung BD on 11/12/18.
//  Copyright © 2018 Benjamin. All rights reserved.
//

import Foundation
import FirebaseAuth

extension User {
    func hasTwitterProvider() -> Bool {
        return providerData.contains { $0.providerID == AuthProvider.twitter.rawValue }
    }
}

extension  Sequence where Iterator.Element == String {
    func hasTwitterProvider() -> Bool {
        return contains { $0 == AuthProvider.twitter.rawValue }
    }
    
    func hasRegistered() -> Bool {
        return contains { $0 == AuthProvider.password.rawValue }
    }
}
