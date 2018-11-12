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
    
    var currentLocation:TWLocation = TWLocation()
    let userDefault = UserDefaults.standard
    
    let kAccessToken:String = "accessToken"
    let kExpireTime:String = "expireTime"
    let kExpireTimeForTWTrending:String = "kExpireTimeForTWTrending"
    let urlFileOfCurrentLocation = Utility.getDirectory(withFileDirectory: "currentLocation.data")
    
    var isExpireToken:Bool {
        return false
//        return expireTimeForAccessToken <= Int64(Date().timeIntervalSince1970)
    }
    
    var isTWExpire:Bool {
        return expireTimeForTWTrending <= Int64(Date().timeIntervalSince1970)
    }

    
    init() {
        accessToken = userDefault.string(forKey: kAccessToken) ?? ""
        expireTimeForAccessToken = userDefault.object(forKey: kExpireTime) as? Int64 ?? Int64(Date().timeIntervalSince1970)
        expireTimeForTWTrending = userDefault.object(forKey: kExpireTimeForTWTrending) as? Int64 ?? Int64(Date().timeIntervalSince1970)
        
        getCurrentLocationFromLocal()
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
    
    func resetExpireTimeForRequestToTwitter() {
        let expireTime = Int64(Date().timeIntervalSince1970 + 5*60)
        userDefault.set(expireTime, forKey: kExpireTimeForTWTrending)
        self.expireTimeForTWTrending = expireTime
    }
    
    func getCurrentLocationFromLocal() {
        if let dataCurrentLoc = loadResponseString(fromURL: urlFileOfCurrentLocation) {
            let decoder = JSONDecoder()
            currentLocation = try! decoder.decode(TWLocation.self, from: dataCurrentLoc)
        }
    }
    
    func saveCurrentLocation(loc:TWLocation) {
        currentLocation = loc
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(loc)
        
        
        saveResponseStringToFile(response: data, withURL: urlFileOfCurrentLocation)
    }
    
    func saveResponseStringToFile(response:Data,withURL url:URL) {
        do {
            try response.write(to: url, options: .atomic)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadResponseString(fromURL url:URL) -> Data? {
        do {
            let contentFile = try Data(contentsOf: url)
            return contentFile
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
