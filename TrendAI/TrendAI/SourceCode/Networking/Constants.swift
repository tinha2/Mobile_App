//
//  Constant.swift
//  IMuzik
//
//  Created by nguyen.manh.tuanb on 24/12/2018.
//  Copyright © 2018 nguyen.manh.tuanb. All rights reserved.
//

import Foundation

struct Constants {
    struct Server {
        
        static let domainName = "http://ws.audioscrobbler.com/2.0/"
        static let httpTokenHeader = "Authorization"
        static let authenUsername = ""
        static let authenPassword = ""
        
        static let apiKey = "2f701b38f6d20ca1e24e5f4948dcd1f9"
        static let shareSecret = "64543cbb2dcf5747aa23f9cee70b6c35"
        static let appName = "IMuzik"
        static let registerName = "tuanhust2010"
    }
    
    struct UserDefaultsKey {
        static let AccessToken = "AccessToken"
    }
}
