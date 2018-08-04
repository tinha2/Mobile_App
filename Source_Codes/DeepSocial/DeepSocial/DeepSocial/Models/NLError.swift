//
//  NLError.swift
//  DeepSocial
//
//  Created by Chung BD on 4/14/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation

enum NLError: Error {
    case invalidURL(String)
    case invalidParameter(Any)
    case invalidJSON(String)
    case invalibJsonBody(String)
    case invalidResponse(Any)
    case cannotTakeAccessToken
}
