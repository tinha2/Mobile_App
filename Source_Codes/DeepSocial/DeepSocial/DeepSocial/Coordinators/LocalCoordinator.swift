//
//  LocalCoordinator.swift
//  DeepSocial
//
//  Created by Chung BD on 4/29/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation

class LocalCoordinator {
    var accessToken:String
    var expireTimeForAccessToken:Int64
    
    var expireTimeForTWTrending:Int64
    
    
    static let share = LocalCoordinator()
    
    let userDefault = UserDefaults.standard
    
    let kAccessToken:String = "accessToken"
    let kExpireTime:String = "expireTime"
    let kExpireTimeForTWTrending:String = "kExpireTimeForTWTrending"
    
    var isExpireToken:Bool {
        return expireTimeForAccessToken <= Int64(Date().timeIntervalSince1970)
    }
    
    var isTWExpire:Bool {
        return expireTimeForTWTrending <= Int64(Date().timeIntervalSince1970)
    }

    
    init() {
        accessToken = userDefault.string(forKey: kAccessToken) ?? ""
        expireTimeForAccessToken = userDefault.object(forKey: kExpireTime) as? Int64 ?? Int64(Date().timeIntervalSince1970)
        expireTimeForTWTrending = userDefault.object(forKey: kExpireTimeForTWTrending) as? Int64 ?? Int64(Date().timeIntervalSince1970)
    }
    
    func updateAccessToken(withResponse json:[String:Any]) {
        if let token = json["access_token"] as? String {
            userDefault.set(token, forKey: kAccessToken)
            accessToken = token
            
        }
        
        if let _ = json["expires_in"] as? Int {
            let expireTime = Int64(Date().timeIntervalSince1970 + 60*60)
            userDefault.set(expireTime, forKey: kExpireTime)
            self.expireTimeForAccessToken = expireTime
        }
    }
    
    func resetExpireTimeForTwitterTrending() {
        let expireTime = Int64(Date().timeIntervalSince1970 + 5*60)
        userDefault.set(expireTime, forKey: kExpireTimeForTWTrending)
        self.expireTimeForTWTrending = expireTime
    }
    
    
}
