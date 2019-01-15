//
//  SocialManager.swift
//  TrendAI
//
//  Created by Administrator on 11/27/18.
//  Copyright © 2018 Benjamin. All rights reserved.
//

import Foundation
import OAuthSwift
import SafariServices

typealias CompletionTwitterSession = (_ session:TwitterSession?,_ error:Error?) -> Void

class SocialManager:NSObject {
    static let shared = SocialManager()
    var oauthswift: OAuth1Swift!
    var handle: OAuthSwiftRequestHandle!
    var completion:CompletionTwitterSession?
    
    func loginWithTwitter(_ fromViewController:UIViewController,_ completion:@escaping CompletionTwitterSession) {
        
        print("loginWithTwitter")
        self.completion = completion
        
        oauthswift =  OAuth1Swift(consumerKey: "W2QMzpCSBc723h6x1joBuNnDf",
                                  consumerSecret: "GT7MMqpHBrvNjQczQp84DPHBXSUWuOWaUaZGdj1jFYnbijXwXN",
                                  requestTokenUrl: "https://api.twitter.com/oauth/request_token",
                                  authorizeUrl: "https://api.twitter.com/oauth/authorize",
                                  accessTokenUrl: "https://api.twitter.com/oauth/access_token")
        let safariHandler = SafariURLHandler(viewController: fromViewController, oauthSwift: oauthswift)
        safariHandler.delegate = self
        oauthswift.authorizeURLHandler = safariHandler
        
        // [2] Trigger OAuth2 dance
        guard let rwURL = URL(string: "twitterkit-W2QMzpCSBc723h6x1joBuNnDf://") else { return }
        
        handle = oauthswift
            .authorize(withCallbackURL: rwURL,
                       success: { (credential, response, parameters) in
                        print("OAuthToken: \(credential.oauthToken)")
                        print("OAuthSecret: \(credential.oauthTokenSecret)")
                        print("User ID: \(parameters["user_id"]!)")
                        print("Response \(String(describing: response))")
                        print("parameters \(parameters)")
                        
                        let user = UserModel()
                        let twitterInfo = TwitterInfo()
                        twitterInfo.screenName = parameters["screen_name"] as? String
                        twitterInfo.userId = parameters["user_id"] as? String
                        twitterInfo.oAuthToken = credential.oauthToken
                        twitterInfo.oAuthSecret = credential.oauthTokenSecret
                        user.twitterInfo = twitterInfo
                        gCurrentUser.value = user
                        UserDefaultHelper.saveUser(user)
                        
                        TWTRTwitter.sharedInstance().sessionStore.saveSession(withAuthToken: credential.oauthToken, authTokenSecret: credential.oauthTokenSecret, completion: { (_, errorSession) in
                            if errorSession != nil {
                                print("loginWithTwitter errorSession != nil")
                                completion(nil,errorSession)
                            } else {
                                let client = TWTRAPIClient.init(userID: parameters["user_id"] as? String)
                                
                                client.requestEmail { email, error in
                                    if (email != nil) {
                                        let session = TwitterSession.init(token: credential.oauthToken, secret: credential.oauthTokenSecret,email: email!)
                                        completion(session,nil)
                                    } else {
                                        print("error requestEmail: \(String(describing: error?.localizedDescription))");
                                        completion(nil,error)
                                    }
                                }
                            }
                        })
                        
            }) { (error) in
                print("loginWithTwitter fail \(error.localizedDescription)")
                completion(nil,error)
        }
        
    }
}

extension SocialManager:SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        completion?(nil,TWError.userCancel)
    }
}
