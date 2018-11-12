//
//  Attribute.swift
//  DeepSocial
//
//  Created by Chung BD on 5/28/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation

enum Attribute {
    case NLEntity, NLCategory, NLSentence, CVLabel, CVWebDectection, CVSafeSearchAnnotation, CVTextAnnotation, CVImageProperties, GCConfidence
    
    var estimatedHeightOfHeadeView:CGFloat {
        switch self {
        case .NLEntity:
            return 45
        case .NLCategory:
            return 60
        case .CVTextAnnotation:
            return UIScreen.main.bounds.size.width
        default:
            return 0
        }
    }
    
    var estimateRowHeight:CGFloat {
        switch self {
        case .NLEntity:
            return 127
        case .NLSentence:
            return 50
        case .CVLabel,.CVImageProperties:
            return 60
        case .CVWebDectection:
            return 44
        case .GCConfidence:
            return 68
        case .CVSafeSearchAnnotation:
            return 45
        case .CVTextAnnotation:
            return 60
        default:
            return 0
        }
    }
    
    var segmentTitle:String {
        switch self {
        case .NLEntity:
            return "Entity Extraction"
        case .NLSentence:
            return "Sentiment Analysis"
        case .NLCategory:
            return "Content Classification"
        case .CVLabel:
            return "Labels"
        case .CVWebDectection:
            return "Web"
        case .CVTextAnnotation:
            return "Documents"
        case .CVImageProperties:
            return "Properties"
        case .CVSafeSearchAnnotation:
            return "Safe Search"
        case .GCConfidence:
            return "Confidence"
            
        }
    }
    
    var titlesOfSections:[String] {
        switch self {
        case .CVWebDectection:
            return ["Web Entities","Pages with Matched Images"]
        case .NLSentence:
            return ["Document & Sentence Level Sentiment","Entity Level Sentiment"]
        case .CVImageProperties:
            return ["Dominant Colors"]
        default:
            return []
        }
    }
}
