//
//  EntitiesSection.swift
//  DeepSocial
//
//  Created by Chung Bui on 4/16/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation

struct EntitiesSection {
    let name:String
    let entities:[NLEntity]
    let isSelected:Bool
    
    init(name:String,entities:[NLEntity]) {
        self.name = name
        self.entities = entities
        self.isSelected = false
    }
}

