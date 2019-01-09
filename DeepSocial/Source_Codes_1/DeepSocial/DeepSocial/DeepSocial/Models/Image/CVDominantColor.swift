//
//  CVDominantColor.swift
//  DeepSocial
//
//  Created by Chung BD on 6/24/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation

struct CVDominantColor {
    let score:CGFloat
    let pixelFraction:CGFloat
    let colorJson:CommonDic
    
    var redColor:Int {
        if let red:Int = colorJson["red"] as? Int {
            return red
        }
        
        return 0
    }
    
    var greenColor:Int {
        if let green:Int = colorJson["green"] as? Int {
            return green
        }
        
        return 0
    }
    
    var blueColor:Int {
        if let blue:Int = colorJson["blue"] as? Int {
            return blue
        }
        
        return 0
    }
    
    var color:UIColor {
        let convertColor = UIColor(red: CGFloat(redColor)/255, green: CGFloat(greenColor)/255, blue: CGFloat(blueColor)/255, alpha: 1)
        
        return convertColor
    }
    
    init?(json:[String:Any]) {
        guard let pixelFraction = json["pixelFraction"] as? CGFloat,
            let score = json["score"] as? CGFloat,
            let color = json["color"] as? CommonDic else {
                return nil
        }
        
        self.pixelFraction = pixelFraction
        self.score = score
        self.colorJson = color
    }
    
    static func initiateForTesting() -> [CVDominantColor] {
        do {
            if let jsonData = JSON_STRING_IMAGE_PROPERTIES.data(using: .utf8),
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String:Any],
                let imagePropertiesAnnotation = json["imagePropertiesAnnotation"] as? CommonDic,
                let dominantColors = imagePropertiesAnnotation["dominantColors"] as? CommonDic,
            let colors = dominantColors["colors"] as? [CommonDic] {
                return colors.compactMap(CVDominantColor.init)
                    .sorted { $0.pixelFraction > $1.pixelFraction }
            }
            
            return []
        } catch {
            return []
        }
    }
}
