//
//  UserDefault.swift
//  eschool
//
//  Created by nguyen.manh.tuanb on 8/15/18.
//  Copyright © 2018 nguyen.manh.tuanb. All rights reserved.
//

import Foundation

struct UserDefaultHelper {
    
    static func resetUserDefault() {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.AccessToken)
    }
    
    static func saveAccessToken(token: String) {
        UserDefaults.standard.setValue(token.encrypt(), forKey: Constants.UserDefaultsKey.AccessToken)
        UserDefaults.standard.synchronize()
    }
    
    static func getAccessToken() -> String {
        guard let token = UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.AccessToken) as? String else {
            return ""
        }
        return token.decrypt()
    }
}
