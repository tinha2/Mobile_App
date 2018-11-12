//
//  Response.swift
//  SohaPay
//
//  Created by Chung BD on 3/26/17.
//  Copyright © 2017 Bun Chu. All rights reserved.
//

import Foundation

typealias CommonDic = [String:Any]

enum Response {
    case data(_: CommonDic)
    case data_list(_: [CommonDic])
    case raw(_: Data)
    case status(_: eResponseCode, _:String?,_: Error?)
    
    init(_ response:CommonDic) {
        
        if let errorCode = response["error"] as? CommonDic
        , let message = errorCode["message"] as? String {
            self = .status(.error,message,nil)
            return
        }
        
        self = .data(response)
    }
}
