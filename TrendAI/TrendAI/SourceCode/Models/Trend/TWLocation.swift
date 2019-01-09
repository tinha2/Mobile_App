//  TWLocation.swift
//  DeepSocial
//
//  Created by Chung BD on 8/11/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation

struct TWLocation: Codable,CustomStringConvertible {
    var country:String
    var countryCode:String
    var name:String
    var parentid:Int
    var placeType:PlaceType
    var url:String
    var woeid:Int
    
    var description: String {
        return "\(name), \(country), parentID: \(parentid), woeid: \(woeid)"
    }
    
    init() {
        country = ""
        countryCode = ""
        name = "World"
        parentid = 0
        placeType = PlaceType(code: 0, name: "")
        url = ""
        woeid = 1
    }
    
    init(dic:CommonDic) {
        
        if let country = dic["country"] as? String {
            self.country = country
        } else {
            self.country = ""
        }
        
        if let countryCode = dic["countryCode"] as? String {
            self.countryCode = countryCode
        } else {
            self.countryCode = ""
        }
        if let name = dic["name"] as? String {
            self.name = name
        } else {
            self.name = ""
        }
        if let parentid = dic["parentid"] as? Int {
            self.parentid = parentid
        } else {
            self.parentid = 0
        }
        if let placeType = dic["placeType"] as? [String:Any],
            let code = placeType["code"] as? Int,
            let name = placeType["name"] as? String {
            self.placeType = PlaceType(code: code, name: name)
        } else {
            self.placeType = PlaceType(code: 0, name: "")
        }
        if let url = dic["url"] as? String {
            self.url = url
        } else {
            self.url = ""
        }
        if let woeid = dic["woeid"] as? Int {
            self.woeid = woeid
        } else {
            self.woeid = 0
        }
    }
    
    static func initiate(fromArray array:[CommonDic]) -> [TWLocation] {
        var listOutput = [TWLocation]()
        
        listOutput = array.map { TWLocation(dic: $0) }
      
        let sorted = listOutput.sorted(by: { $0.name < $1.name })
      
      listOutput = []
      var previousItem = sorted[0]
      listOutput.append(previousItem)
      
      for i in 1..<sorted.count {
        let currentItem = sorted[i]
        if previousItem.name == currentItem.name {
          if currentItem.woeid != 1 {
            continue
          }
        } else {
          listOutput.append(currentItem)
          previousItem = currentItem
        }
      }
      
        return listOutput
    }
}

struct PlaceType: Codable {
    var code:Int
    var name:String
}
