//
//  FeatureItem.swift
//  DeepSocial
//
//  Created by Chung BD on 5/26/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation
import UIKit

enum Feature {
    case text
    case image(UIImage?)
    case voiceToText
    case textToSpeech
    
    var attributes:[Attribute] {
        switch self {
            case .text:
                return [Attribute.NLEntity, Attribute.NLSentence, Attribute.NLCategory]
            case .image:
                return [Attribute.CVLabel, Attribute.CVWebDectection, Attribute.CVTextAnnotation, Attribute.CVImageProperties, Attribute.CVSafeSearchAnnotation]
            case .voiceToText:
                return [Attribute.GCConfidence]
            case .textToSpeech:
                return []
        }
    }
    
}

struct FeatureItem {
    var feature:Feature
    let title:String
    
    // only for image feature
    func getImage() -> UIImage? {
        switch feature {
        case .image(let img):
            return img
        default:
            return nil
        }
    }
}
