//
//  ViewController.swift
//  TrendAI
//
//  Created by Chung BD on 11/5/18.
//  Copyright © 2018 Benjamin. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(session?.userName)");
            } else {
                print("error: \(error?.localizedDescription)");
            }
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handingFlowGoingToHome()
    }

    func handingFlowGoingToHome() {
        if Auth.auth().currentUser != nil {
            // User is signed in.
            self.showHomeScreen()
        } else {
            // No user is signed in.

        }
    }
    
//    func getLoginByFireBase() -> UIViewController {
//        let providers:[FUIAuthProvider] = [
//            FUITwitterAuth()
//        ]
//
//        let authUI = FUIAuth.defaultAuthUI()
//        // You need to adopt a FUIAuthDelegate protocol to receive callback
//        authUI?.delegate = self
//        authUI?.providers = providers
//        authUI?.shouldHideCancelButton = true
//
//        let authViewController = authUI!.authViewController()
//
//        return authViewController
//    }
  
    func showHomeScreen() {
        
    }
}

//extension ViewController:FUIAuthDelegate {
//    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
//        if error == nil {
//            if let authResult = authDataResult {
//                print("Result logined. \(authResult)")
//            }
//
//            if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
//                print("userID from Twitter. \(userID)")
//            }
//            print("Chung test")
//        } else {
//            print("Result logined: fail ")
//        }
//    }
//
//}

