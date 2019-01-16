//
//  CSConfidence.swift
//  DeepSocial
//
//  Created by Chung BD on 5/30/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation

struct CSConfidence {
    let transcript:String
    let confidence:CGFloat
    
    init?(json:[String:Any]) {
        guard let transcript = json["transcript"] as? String,
            let confidence = json["confidence"] as? CGFloat else {
                return nil
        }
        
        self.transcript = transcript
        self.confidence = confidence

    }
    
    static func initiateForTesting() -> [CSConfidence] {
        do {
            if let jsonData = JSON_STRING_VOICE_SYNTHESIS.data(using: .utf8),
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String:Any],
                let annotations = json["results"] as? [CommonDic], annotations.count > 0,
                let alternatives = annotations[0]["alternatives"] as? [CommonDic] {
                
                return alternatives.compactMap(CSConfidence.init)
                        .sorted { $0.confidence > $1.confidence }
            }
            return []
        } catch {
            return []
        }
    }
}
