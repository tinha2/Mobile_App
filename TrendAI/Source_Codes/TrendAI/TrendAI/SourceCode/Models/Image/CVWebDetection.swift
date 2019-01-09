//
//  NLWebDetection.swift
//  DeepSocial
//
//  Created by Chung BD on 5/28/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation

struct CVWebDetection {
    let webEntities:[CVWebEntity]
    let matchingPage:[CVMatchingPage]
    let visuallySimilarImages:[String]
    init?(json:[String:Any]) {
        if let webDetection = json["webDetection"] as? CommonDic,
            let webEntities = webDetection["webEntities"] as? [CommonDic] {
            self.webEntities = webEntities.compactMap(CVWebEntity.init)

            if let matchingPage = webDetection["pagesWithMatchingImages"] as? [CommonDic] {
                self.matchingPage = matchingPage.compactMap(CVMatchingPage.init)
                self.visuallySimilarImages = []
                
            } else {
                if let matchingPage = webDetection["visuallySimilarImages"] as? [CommonDic] {
                    self.visuallySimilarImages = matchingPage.compactMap { $0["url"] as? String }
                } else {
                    self.visuallySimilarImages = []
                }
                
                self.matchingPage = []
            }
        } else {
            return nil
        }
        
    }
    
    init() {
        webEntities = []
        matchingPage = []
        visuallySimilarImages = []
    }
    
    static func initiateForTesting() -> CVWebDetection? {
        do {
            if let jsonData = JSON_STRING_IMAGE_EXTRACTION.data(using: .utf8),
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String:Any] {
                return CVWebDetection(json: json)
            }
            return nil
        } catch {
            return nil
        }
    }
}
