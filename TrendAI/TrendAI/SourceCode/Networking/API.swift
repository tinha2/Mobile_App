//
//  API.swift
//  IMuzik
//
//  Created by nguyen.manh.tuanb on 24/12/2018.
//  Copyright © 2018 nguyen.manh.tuanb. All rights reserved.
//

import Foundation
import Alamofire

enum API {
    case login
}

extension API {
    var baseURL: URL {
        return URL(string: Constants.Server.domainName)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "\(baseURL)/"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
    }
}

}
