//
//  NLSentence.swift
//  DeepSocial
//
//  Created by Chung BD on 5/1/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation

struct NLSentence {
    let content:String
    let sentiment:NLSentiment
    
    init?(json:[String:Any]) {
        guard let text = json["text"] as? [String:Any],
            let content = text["content"] as? String,
            let sentimentJson = json["sentiment"] as? [String:Any],
            let sentiment = NLSentiment(json: sentimentJson) else {
                return nil
        }
        
        self.content = content
        self.sentiment = sentiment
    }
    
    init(content:String,sentiment:NLSentiment) {
        self.content = content
        self.sentiment = sentiment
    }
    
    static func initiateForTesting() -> [NLSentence] {
        do {
            if let jsonData = JSON_STRING.data(using: .utf8),
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String:Any],
                let sentences = json["sentences"] as? [[String: Any]] {
                
                var sentencesOutput:[NLSentence] = sentences.compactMap(NLSentence.init)
                
                if let entireDocumentJson = json["documentSentiment"] as? [String:Any],
                    let entireDocumentSentiment = NLSentiment(json: entireDocumentJson) {
                    let entireDocument = NLSentence(content: "Entire Document", sentiment: entireDocumentSentiment)
                    sentencesOutput.insert(entireDocument, at: 0)
                }
                
                return sentencesOutput
            }
            return []
        } catch {
            return []
        }
    }
}
