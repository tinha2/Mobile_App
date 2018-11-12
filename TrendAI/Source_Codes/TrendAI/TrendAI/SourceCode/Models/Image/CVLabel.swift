//
//  NLLabel.swift
//  DeepSocial
//
//  Created by Chung BD on 5/28/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation

struct CVLabel {
    let description:String
    let score:CGFloat
    
    init?(json:[String:Any]) {
        guard let description = json["description"] as? String,
            let score = json["score"] as? CGFloat else {
                return nil
        }
        
        self.description = description
        self.score = score
        
    }
    
    static func initiateForTesting() -> [CVLabel] {
        do {
            if let jsonData = JSON_STRING_IMAGE_EXTRACTION.data(using: .utf8),
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String:Any],
                let annotations = json["labelAnnotations"] as? [[String: Any]] {
                return annotations.compactMap(CVLabel.init)
                    .sorted { $0.score > $1.score }
            }
            return []
        } catch {
            return []
        }
    }
}
