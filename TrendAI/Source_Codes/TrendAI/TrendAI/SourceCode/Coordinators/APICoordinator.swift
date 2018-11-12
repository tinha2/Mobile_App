//
//  APICoordinator.swift
//  DeepSocial
//
//  Created by Chung BD on 8/11/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation
import RxSwift

class APICoordinator {
    static let share = APICoordinator()
    
    let urlFileLocations = Utility.getDirectory(withFileDirectory: "locations.data")
    
    init() {
        
    }
    
    let bag = DisposeBag()
    
    func getAvailableLocationFromTwitter(completion:@escaping ([TWLocation],TwitterError?)->()) {
        if let response = LocalCoordinator.share.loadResponseString(fromURL: urlFileLocations), !LocalCoordinator.share.isTWExpire {
            do {
                let listDic = try TwitterAPI.instance.doProcessingOnList(response: response)
                completion(TWLocation.initiate(fromArray: listDic),nil)
            } catch {
                completion([],TwitterError.wrongFormat)
            }
        } else {
            TwitterAPI.instance.getAvailableLocations()
                .subscribe(onNext: { [unowned self](response:Response) in
                    do {
                        switch response {
                        case .raw(let data):
                            LocalCoordinator.share.saveResponseStringToFile(response: data, withURL: self.urlFileLocations)
                            let listDic = try TwitterAPI.instance.doProcessingOnList(response: data)
                            completion(TWLocation.initiate(fromArray: listDic),nil)
                        default:
                            completion([],nil)
                        }
                    } catch {
                        completion([],error as? TwitterError)
                    }
                    LocalCoordinator.share.resetExpireTimeForRequestToTwitter()
                }, onError: { (error) in
                    completion([],error as? TwitterError)
                })
                
                .disposed(by: bag)
        }
    }
    
    func getTrendingsFromTwitter(geoID:Int, completion:@escaping ([TWTrend],TwitterError?)->()) {
        
        let urlFileTrending = Utility.getDirectory(withFileDirectory: "trending_\(geoID).data")
        
        if let response = LocalCoordinator.share.loadResponseString(fromURL: urlFileTrending), !LocalCoordinator.share.isTWExpire {
            do {
                let listDic = try TwitterAPI.instance.doProcessingOnItem(response: response, key: "trends")
                let list = TWTrend.initiate(fromArray: listDic)
                print("List local: \(list.count)")
                completion(list,nil)
            } catch {
                completion([],TwitterError.wrongFormat)
            }
        } else {
            TwitterAPI.instance.getTrends(withWOEID: geoID)
                .subscribe(onNext: { (response:Response) in
                    do {
                        switch response {
                        case .raw(let data):
                            LocalCoordinator.share.saveResponseStringToFile(response: data, withURL: urlFileTrending)
                            let listDic = try TwitterAPI.instance.doProcessingOnItem(response: data, key: "trends")
                            let trends = TWTrend.initiate(fromArray: listDic)
                            print("List response: \(trends.count)")
                            completion(trends,nil)
                        default:
                            completion([],nil)
                        }
                    } catch {
                        completion([],error as? TwitterError)
                    }
                    LocalCoordinator.share.resetExpireTimeForRequestToTwitter()
                    }, onError: { (error) in
                        completion([],error as? TwitterError)
                })
                .disposed(by: bag)
        }
    }
    
}
