//
//  NLSentiment.swift
//  DeepSocial
//
//  Created by Chung BD on 4/15/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation

struct NLSentiment {
    let magnitude:CGFloat
    let score:CGFloat
    
    init?(json:[String:Any]) {
        guard let magnitude = json["magnitude"] as? CGFloat,
            let score = json["score"] as? CGFloat else {
                return nil
        }
        
        self.magnitude = magnitude
        self.score = score
    }
    
}
