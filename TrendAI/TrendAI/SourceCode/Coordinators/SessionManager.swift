//
//  SessionManager.swift
//  TrendAI
//
//  Created by Administrator on 11/27/18.
//  Copyright © 2018 Benjamin. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias FIBUser = User

enum TWError:Error {
  case userCancel
}

enum FIBAuthError:Error {
    case twitterExistByAnother
    case emailUsedByLogin(String)
    case userNotFound
    case emailExistInTwitter
    case notDetermine
}

typealias CompletionUserStatus = (User?,FIBAuthError?)->Void

class SessionManager {
    static let shared = SessionManager()
    var onChangedTwitterProvider:((Bool)->Void)?
    
    static func loginWithTwitter(_ fromViewController:UIViewController,_ completion:@escaping CompletionError) {
        SocialManager.shared.loginWithTwitter(fromViewController) { (session, error) in
            if error != nil {
                completion(error)
            } else if let unnilSession = session {
                fromViewController.view.showLoading()
                let credential = TwitterAuthProvider.credential(withToken: unnilSession.token, secret: unnilSession.secret)
                
                Auth.auth().signInAndRetrieveData(with: credential, completion: { (_, errorAuth) in
                    if let unilError = errorAuth as NSError? {
                        switch unilError.code {
                        case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                            completion(FIBAuthError.emailUsedByLogin(unnilSession.email))
                        default:
                            completion(errorAuth)
                        }
                    } else {
                        completion(nil)
                    }
                    fromViewController.view.hideLoading()
                })
            }
        }
    }
    
    static func addTwitterAccount(_ fromViewController:UIViewController,_ completion:@escaping CompletionUserStatus) -> Void {
        let sessionManager = SessionManager.shared
        SocialManager.shared.loginWithTwitter(fromViewController) { (session, error) in
            if error != nil {
                sessionManager.onChangedTwitterProvider?(sessionManager.hasTwitterProvider())
                completion(nil, FIBAuthError.notDetermine)
//                UIManager.showErrorAlert(withViewController: fromViewController, error: error!)
            } else if let unnilSession = session {
                fromViewController.view.showLoading()
                let credential = TwitterAuthProvider.credential(withToken: unnilSession.token, secret: unnilSession.secret)
                SessionManager.shared.getCurrentUser()?.linkAndRetrieveData(with: credential, completion: { (result, errorAuth) in
                    sessionManager.onChangedTwitterProvider?(sessionManager.hasTwitterProvider())
                    if let unilError = errorAuth as NSError? {
                        switch unilError.code {
                            case AuthErrorCode.credentialAlreadyInUse.rawValue:
                                completion(nil, FIBAuthError.twitterExistByAnother)
//                                UIManager.showAlert(withViewController: fromViewController, content: "The recent Twitter has already used. Please login another Twitter account!")
                            default:
//                                UIManager.showErrorAlert(withViewController: fromViewController, error: unilError)
                                completion(nil, FIBAuthError.notDetermine)
                        }
                    } else {
                        TWTRTwitter.sharedInstance().sessionStore.saveSession(withAuthToken: unnilSession.token, authTokenSecret: unnilSession.secret, completion: { (_, errorSession) in
                            if errorSession != nil {
                                print("errorSession != nil")
//                                UIManager.showErrorAlert(withViewController: fromViewController, error: errorSession!)
                            }
                        })
                        completion(result?.user,nil)
                    }
                    fromViewController.view.hideLoading()
                })
            }
        }
    }
    
    static func loginWithTwitterSession(_ session:TwitterSession,_ completion:@escaping CompletionError) {
        let credential = TwitterAuthProvider.credential(withToken: session.token, secret: session.secret)
        Auth.auth().signInAndRetrieveData(with: credential, completion: { (_, errorAuth) in
            if errorAuth != nil {
                completion(errorAuth)
            } else {
                completion(nil)
            }
        })
    }
    
    static func createUser(withUsername username:String, password:String,_ completion:@escaping CompletionError) {
        Auth.auth().createUser(withEmail: username, password: password) { (authResult, error) in
            guard let _ = authResult?.user, error == nil else {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    static func signIn(withEmail email:String, password:String,_ completion:@escaping CompletionError) {
        fetchProviders(fromEmail: email) { (error) in
            if let rError = error {
                completion(rError)
            } else {
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if let unilError = error as NSError? {
                        switch unilError.code {
                        case AuthErrorCode.userNotFound.rawValue:
                            completion(FIBAuthError.userNotFound)
                        default:
                            completion(unilError)
                        }
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    static func fetchProviders(fromEmail email:String,_ completion:@escaping CompletionError) {
        Auth.auth().fetchProviders(forEmail: email) { (providers, error) in
            if let error = error {
                completion(error)
            } else {
                guard let rProviders = providers else {
                    completion(nil)
                    return
                }

                if rProviders.hasTwitterProvider() {
                    completion(FIBAuthError.emailExistInTwitter)
                    return
                }

                if rProviders.hasRegistered() {
                    completion(nil)
                    return
                }
                
            }
        }
    }
    
    func getCurrentUser() -> FIBUser? {
        if let user = Auth.auth().currentUser {
            return user
        }
        
        return nil
        
        
    }
    
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch (let e) {
            print(e.localizedDescription)
            return false
        }
    }
    
    func hasTwitterProvider() -> Bool {
        guard let user = getCurrentUser() else {
            print("hasTwitterProvider no user logined ")
            return false
        }
        
        for (_,value) in user.providerData.enumerated() {
            
            if value.providerID == AuthProvider.twitter.rawValue {
                return true
            }
        }
        
        return false
    }
}
