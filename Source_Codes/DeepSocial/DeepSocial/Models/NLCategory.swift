//
//  NLCategory.swift
//  DeepSocial
//
//  Created by Chung BD on 4/16/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation

struct NLCategory {
    let name:String
    let confidence:CGFloat
    
    init?(json:[String:Any]) {
        guard let name = json["name"] as? String,
            let confidence = json["confidence"] as? CGFloat else {
                return nil
        }
        
        self.name = name
        self.confidence = confidence
    }
    
    static func initiateForTesting() -> [NLCategory] {
        do {
            if let jsonData = JSON_STRING.data(using: .utf8),
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String:Any],
                let entities = json["categories"] as? [[String: Any]] {
                return entities.compactMap(NLCategory.init)
                    .sorted { $0.name < $1.name }
            }
            return []
        } catch {
            return []
        }
    }
}
