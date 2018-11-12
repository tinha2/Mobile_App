//
//  TWTrend.swift
//  DeepSocial
//
//  Created by Chung BD on 7/27/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation

struct TWTrend {
    let name:String
    let url:String
    let query:String
    let tweet_volume:Int
    
    var displayVolume:String {
        let quotientWith1K:Int = Int(CGFloat(tweet_volume)/1000)
        
        if quotientWith1K > 1 {
            return "\(quotientWith1K)K"
        } else {
            return "\(tweet_volume)"
        }
    }
    
    init() {
        name = ""
        url = ""
        query = ""
        tweet_volume = 0
    }
    
    init(dic:CommonDic) {
        
        if let name = dic["name"] as? String {
            self.name = name
        } else {
            self.name = ""
        }
        
        if let url = dic["url"] as? String {
            self.url = url
        } else {
            self.url = ""
        }
        
        if let query = dic["query"] as? String {
            self.query = query
        } else {
            self.query = ""
        }
        
        if let tweet_volume = dic["tweet_volume"] as? Int {
            self.tweet_volume = tweet_volume
        } else {
            self.tweet_volume = 0
        }
    }
    
    static func initiate(fromArray array:[CommonDic]) -> [TWTrend] {
        var listOutput = [TWTrend]()
        
        listOutput = array.map {
                        TWTrend(dic: $0)
                    }
        
        return listOutput
    }
}
