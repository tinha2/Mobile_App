//
//  FirebaseService.swift
//  TrendAI
//
//  Created by nguyen.manh.tuanb on 14/01/2019.
//  Copyright © 2019 Benjamin. All rights reserved.
//

import Foundation
import FirebaseDatabase
import RxSwift
import SwiftyJSON
import RxCocoa

let gCurrentUser = Variable<UserModel>(UserModel())

final class FirebaseService {
    
    static let instance: FirebaseService = {
        let instance = FirebaseService()
        instance.connectDatabase()
        return instance
    }()
    
    private var twitterRef: DatabaseReference?
    private(set) var disposeBag = DisposeBag()
    
    private let twitterPath: String = "twitter"
    private let socialPath: String = "social"
    
    private func connectDatabase() {
        twitterRef = Database.database().reference().child("TrendAI")
    }
    
    func saveProfileData() {
        guard let fUser = SessionManagers.shared.getCurrentUser() else { return }
        guard let twitterRef = twitterRef else { return }
        let userId = fUser.uid
        var userInfo: [String: Any] = [:]
        userInfo["email"] = fUser.email
        userInfo["displayName"] = fUser.displayName
        userInfo["phoneNumber"] = fUser.phoneNumber
        userInfo["avatar"] = fUser.photoURL?.absoluteString
        
        var twitterInfo: [String: Any] = [:]
        twitterInfo["screen_name"] = gCurrentUser.value.twitterInfo?.screenName
        twitterInfo["userId"] = gCurrentUser.value.twitterInfo?.userId
        twitterInfo["oAuthToken"] = gCurrentUser.value.twitterInfo?.oAuthToken
        twitterInfo["oAuthSecret"] = gCurrentUser.value.twitterInfo?.oAuthSecret
        
        userInfo[twitterPath] = twitterInfo
        twitterRef.child(userId).setValue(userInfo) { (error, _) in
            print("saved data success error \(error?.localizedDescription ?? "")")
        }
    }
    
    func saveTwitterData(_ data: [String: Any]) {
        guard let fUser = SessionManagers.shared.getCurrentUser() else { return }
        guard let twitterRef = twitterRef else { return }
        twitterRef.child(fUser.uid)
            .child(twitterPath)
            .child(socialPath)
            .childByAutoId().setValue(data) { (error, _) in
                print("saved data success error \(error?.localizedDescription ?? "")")
        }
    }
}
