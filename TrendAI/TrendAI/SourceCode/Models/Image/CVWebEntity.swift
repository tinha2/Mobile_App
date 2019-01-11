//
//  CVWebEntity.swift
//  DeepSocial
//
//  Created by Chung BD on 5/28/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation

struct CVWebEntity {
    let entityId:String
    let description:String
    let score:CGFloat
    
    init?(json:[String:Any]) {
        guard let description = json["description"] as? String,
            let score = json["score"] as? CGFloat,
        let entityId = json["entityId"] as? String else {
                return nil
        }
        
        self.description = description
        self.score = score
        self.entityId = entityId
    }
    
    static func initiateForTesting() -> [CVWebEntity] {
        do {
            if let jsonData = JSON_STRING_IMAGE_EXTRACTION.data(using: .utf8),
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String:Any],
                let webDetection = json["webDetection"] as? CommonDic,
                let webEntities = webDetection["webEntities"] as? [CommonDic] {
                return webEntities.compactMap(CVWebEntity.init)
                    .sorted { $0.description < $1.description }
            }
            return []
        } catch {
            return []
        }
    }
}
