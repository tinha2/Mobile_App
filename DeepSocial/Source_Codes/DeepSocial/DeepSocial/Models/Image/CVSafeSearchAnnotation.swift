//
//  CVSafeSearchAnnotation.swift
//  DeepSocial
//
//  Created by Chung BD on 6/15/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation

enum eLikelihood:String,CustomStringConvertible {
    case unknown = "UNKNOWN"
    case veryUnlikely = "VERY_UNLIKELY"
    case possible = "UNLIKELY"
    case likely = "LIKELY"
    case veryLikely = "VERY_LIKELY"
    
    var description: String {
        let rawString = self.rawValue
        let components = rawString.components(separatedBy: "_")
        let joinedComponent = components.joined(separator: " ")
        return joinedComponent.capitalized
    }
}

struct CVSafeSearchAnnotation {
    let feature:String
    let likelihoodRaw:String
    
    var likelihood:eLikelihood {
        if let nonnil = eLikelihood(rawValue: likelihoodRaw) {
            return nonnil
        } else {
            return eLikelihood.unknown
        }
    }
    
    static func initiateWithDictionary(annotations:[String:String]) -> [CVSafeSearchAnnotation] {
        let safeAnnotations:[CVSafeSearchAnnotation] = annotations.keys.compactMap { (k:String) -> CVSafeSearchAnnotation? in
            if let nonnil = annotations[k] {
                let safeSearch = CVSafeSearchAnnotation(feature: k, likelihoodRaw: nonnil)
                return safeSearch
            }
            
            return nil
        }
        
        return safeAnnotations
    }
    
    static func initiateForTesting() -> [CVSafeSearchAnnotation] {
        do {
            if let jsonData = JSON_STRING_IMAGE_EXTRACTION.data(using: .utf8),
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String:Any],
                let annotations = json["safeSearchAnnotation"] as? [String: String] {
                
                let safeAnnotations:[CVSafeSearchAnnotation] = annotations.keys.compactMap { (k:String) -> CVSafeSearchAnnotation? in
                    if let nonnil = annotations[k] {
                        let safeSearch = CVSafeSearchAnnotation(feature: k, likelihoodRaw: nonnil)
                        return safeSearch
                    }
                    
                    return nil
                }
                
                return safeAnnotations
            }
            return []
        } catch {
            return []
        }
    }
}
