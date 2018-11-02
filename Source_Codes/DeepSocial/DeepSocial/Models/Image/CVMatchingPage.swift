//
//  CVMatchingPage.swift
//  DeepSocial
//
//  Created by Chung BD on 5/31/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation

struct CVMatchingPage {
    let url:String
    let pageTitle:String
    let fullMatchingImages:[CommonDic]
    
    init?(json:[String:Any]) {
        guard let url = json["url"] as? String,
            let pageTitle = json["pageTitle"] as? String,
            let fullMatchingImages = json["fullMatchingImages"] as? [CommonDic] else {
                return nil
        }
        
        self.url = url
        self.pageTitle = pageTitle
        self.fullMatchingImages = fullMatchingImages
    }
    
}
