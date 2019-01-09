//
//  CVTextAnnotation.swift
//  DeepSocial
//
//  Created by Chung BD on 5/28/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation

struct CVTextAnnotation {
    let description:String
    let boundingPoly:[CGPoint]
    
    init?(json:[String:Any]) {
        guard let description = json["description"] as? String,
            let boundingPoly = json["boundingPoly"] as? CommonDic,
            let vertices = boundingPoly["vertices"] as? [CommonDic] else {
                return nil
        }
        
        var listOfVertices:[CGPoint] = []
        for vertex in vertices {
            if let x = vertex["x"] as? Int,
                let y = vertex["y"] as? Int {
                listOfVertices.append(CGPoint(x: x, y: y))
            }
        }
        
        self.description = description
        self.boundingPoly = listOfVertices
    }
    
    static func initiateForTesting() -> [CVTextAnnotation] {
        do {
            if let jsonData = JSON_STRING_TEXT_ANNOTATION.data(using: .utf8),
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String:Any],
            let textAnnotations = json["textAnnotations"] as? [CommonDic] {
                return textAnnotations.compactMap(CVTextAnnotation.init)
                        .sorted { $0.description < $1.description }
            }
            
            return []
        } catch {
            return []
        }
    }
}
