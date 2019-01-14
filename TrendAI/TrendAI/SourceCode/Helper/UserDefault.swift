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
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.accessToken)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.userInformation)
    }
    
    static func saveAccessToken(token: String) {
        UserDefaults.standard.setValue(token.encrypt(), forKey: Constants.UserDefaultsKey.accessToken)
        UserDefaults.standard.synchronize()
    }
    
    static func getAccessToken() -> String {
        guard let token = UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.accessToken) as? String else {
            return ""
        }
        return token.decrypt()
    }
    
    static func saveUser(_ user: UserModel) {
        do {
            let userData = try JSONEncoder().encode(user)
            UserDefaults.standard.setValue(userData, forKey: Constants.UserDefaultsKey.userInformation)
        } catch {
            print("save error \(error.localizedDescription)")
        }
    }
    
    static func getUser() -> UserModel? {
        guard let userData = UserDefaults.standard
            .object(forKey: Constants.UserDefaultsKey.userInformation) as? Data else { return nil }
        return try? JSONDecoder().decode(UserModel.self, from: userData)
    }
}
