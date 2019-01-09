//
//  ProviderInfor.swift
//  DeepSocial
//
//  Created by Chung BD on 5/21/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation
import FirebaseAuth

class ProviderInfor {
    var provider:AuthProvider
    var userInfor:UserInfo? = nil
    var image:UIImage? = nil
    
    var isLogined:Bool {
        return userInfor != nil
    }
    
    init() {
        provider = .unknown
    }
    
    init(provider:AuthProvider) {
        self.provider = provider
    }
    
    func update(from userInfor:UserInfo) -> Void {
        provider = userInfor.provider
        self.userInfor = userInfor
    }
}
