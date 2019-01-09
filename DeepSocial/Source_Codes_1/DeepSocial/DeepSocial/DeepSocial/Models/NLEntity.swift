//
//  NLEntity.swift
//  DeepSocial
//
//  Created by Chung BD on 4/14/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation

struct NLEntity {
    let name:String
    let type:String
    let metadata:[String:Any]
    let salience:CGFloat
    let mentions:Any
    let sentiment:NLSentiment
    
    init?(json:[String:Any]) {
        guard let name = json["name"] as? String,
            let type = json["type"] as? String,
            let metadata = json["metadata"] as? [String:Any],
            let salience = json["salience"] as? CGFloat,
            let mentions = json["mentions"],
            let sentimentJson = json["sentiment"] as? [String:Any],
            let sentiment = NLSentiment(json: sentimentJson) else {
            
                return nil
        }
        
        self.name = name
        self.type = type
        self.metadata = metadata
        self.salience = salience
        self.mentions = mentions
        self.sentiment = sentiment
        
    }
    
    var color:UIColor {
        switch type {
        case "CONSUMER_GOOD":
            return hexStringToUIColor(hex: "#981C90")
        case "ORGANIZATION":
            return hexStringToUIColor(hex: "#1922FB")
        case "PERSON":
            return hexStringToUIColor(hex: "#E85D48")
        case "LOCATION":
            return hexStringToUIColor(hex: "#009017")
        case "EVENT":
            return hexStringToUIColor(hex: "#C0A84E")
        case "OTHER":
            return hexStringToUIColor(hex: "#971402")
        default:
            return .black
        }
    }
    
    static func initiateForTesting() -> [NLEntity] {
        do {
            if let jsonData = JSON_STRING.data(using: .utf8),
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String:Any],
                let entities = json["entities"] as? [[String: Any]] {
                    return entities.compactMap(NLEntity.init)
                            .sorted { $0.name < $1.name }
            }
            return []
        } catch {
            return []
        }
    }
}
