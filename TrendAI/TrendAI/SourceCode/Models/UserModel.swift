//
//  UserModel.swift
//  TrendAI
//
//  Created by nguyen.manh.tuanb on 14/01/2019.
//  Copyright © 2019 Benjamin. All rights reserved.
//

import Foundation

final class UserModel: Codable {
    var twitterInfo: TwitterInfo?
}

final class TwitterInfo: Codable {
    var userId: String?
    var oAuthToken: String?
    var oAuthSecret: String?
    var screenName: String?
}

