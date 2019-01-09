//
//  EntitySection.swift
//  DeepSocial
//
//  Created by Chung BD on 4/16/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation
import UIKit

class EntitySection {
    let name:String
    let cells:[NLEntity]
    
    init(name:String,entities:[NLEntity]) {
        self.name = name
        self.cells = entities
    }
    
    var color:UIColor {
        if cells.count > 0 {
            let item = cells[0]
            return item.color
        }
        
        return .black
    }
}
