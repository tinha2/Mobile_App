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
    
    let urlFileLocations = Utility.getInDirectory(withFileDirectory: "locations.data")
    let urlFileNearLocations = Utility.getInDirectory(withFileDirectory: "near_locations.data")
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
  
  func getClosestLocations(location:Coordinate, completion:@escaping ([TWLocation],TwitterError?)->()) {
    if let response = LocalCoordinator.share.loadResponseString(fromURL: urlFileNearLocations), !LocalCoordinator.share.isTWExpire {
      do {
        let listDic = try TwitterAPI.instance.doProcessingOnList(response: response)
        completion(TWLocation.initiate(fromArray: listDic),nil)
      } catch {
        completion([],TwitterError.wrongFormat)
      }
    } else {
      TwitterAPI.instance.getAroundLocations(withLocation: location)
        .subscribe(onNext: { [unowned self](response:Response) in
          do {
            switch response {
            case .raw(let data):
              LocalCoordinator.share.saveResponseStringToFile(response: data, withURL: self.urlFileNearLocations)
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
    
    let urlFileTrending = Utility.getInDirectory(withFileDirectory: "trending_\(geoID).data")
    
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
  
  func getTrendingsFromTwitter(geoIDs:[Int], completion:@escaping ([TWTrend],TwitterError?)->()) {
    getTrendingsFromTwitter(geoID: geoIDs[0], completion: completion)
  }
  
  func getNearTrendingsFromTwitter(location:Coordinate, completion:@escaping ([TWTrend],TwitterError?)->()) {
    getClosestLocations(location: location) { [unowned self](locs, error) in
      if error != nil {
        completion([],error)
      } else {
        self.getTrendingsFromTwitter(geoIDs: locs.map { $0.woeid }, completion: completion)
      }
    }
  }
    
}
