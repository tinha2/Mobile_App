//
//  TwitterAPI.swift
//  DeepSocial
//
//  Created by Chung BD on 8/11/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation
import RxSwift

enum TwitterError:Error {
    case expire
    case connection
    case wrongFormat
    case noData
}

class TwitterAPI {
    static let instance = TwitterAPI()
    
    init() {
        
    }
    
    func getTrends(withWOEID ID:Int = 1) -> Observable<Response> {
        return Observable<Response>.create({ [unowned self](observer) -> Disposable in
            let endpoint = "https://api.twitter.com/1.1/trends/place.json"
            let params = ["id": String(ID)]
            
            self.createGetRequest(endpoint: endpoint, para: params) { (data, error) in
                if error != nil {
                    observer.onError(error!)
                } else {
                    observer.onNext(Response.raw(data!))
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        })
    }
    
    func getAvailableLocations() -> Observable<Response> {
        return Observable<Response>.create({ [unowned self](observer) -> Disposable in
            let endpoint = "https://api.twitter.com/1.1/trends/available.json"
            
            self.createGetRequest(endpoint: endpoint, para: [:]) { (data, error) in
                if error != nil {
                    observer.onError(error!)
                } else {
                    observer.onNext(Response.raw(data!))
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        })
    }
  
  func getAroundLocations(withLocation location:Coordinate) -> Observable<Response> {
    return Observable<Response>.create({ [unowned self](observer) -> Disposable in
      let endpoint = "https://api.twitter.com/1.1/trends/closest.json"
      let params = ["lat": String(location.latitude),"long":String(location.longitude)]
      
      self.createGetRequest(endpoint: endpoint, para: params) { (data, error) in
        if error != nil {
          observer.onError(error!)
        } else {
            if let rData = data {
                observer.onNext(Response.raw(rData))
                observer.onCompleted()
            } else {
                observer.onError(TwitterError.noData)
            }
        }
      }
      
      return Disposables.create()
    })
  }
    
    func createGetRequest(endpoint:String,para:[String:Any],completion:@escaping (Data?,TwitterError?) ->()) {
        guard let session = TWTRTwitter.sharedInstance().sessionStore.session() else {
            completion(nil,TwitterError.expire)
            return
        }
        
        let userID = session.userID
        let apiClient = TWTRAPIClient(userID: userID)
    
        var clientError : NSError?
        
        let request = apiClient.urlRequest(withMethod: "GET", urlString: endpoint, parameters: para, error: &clientError)
        
        apiClient.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(String(describing: connectionError?.localizedDescription))")
                completion(nil,TwitterError.connection)
            }
            
            completion(data,nil)
        }
    }
    
    func doProcessingOnList(response:Data) throws -> [CommonDic] {
        do {
            if let listDic = try JSONSerialization.jsonObject(with: response, options: []) as? [CommonDic], listDic.count > 0 {
                return listDic                
            } else {
                print("doProcessingWhenHavingResponse wrong count")
                throw TwitterError.wrongFormat
            }
        } catch {
            print("doProcessingWhenHavingResponse fail \(error.localizedDescription)")
            throw TwitterError.wrongFormat
        }
    }
    
    func doProcessingOnItem(response:Data,key:String) throws -> [CommonDic] {
        do {
            if let listDic = try JSONSerialization.jsonObject(with: response, options: []) as? [CommonDic], listDic.count > 0 {
              var listFromKey:[CommonDic] = []
              
              for dic in listDic {
                if let list = dic[key] as? [CommonDic] {
                  listFromKey.append(contentsOf: list)
                }
              }
              return listFromKey
            } else {
                print("doProcessingWhenHavingResponse wrong count")
                throw TwitterError.wrongFormat
            }
        } catch {
            print("doProcessingWhenHavingResponse fail \(error.localizedDescription)")
            throw TwitterError.wrongFormat
        }
    }

}
