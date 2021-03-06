//
//  RouteCoordinator.swift
//  DeepSocial
//
//  Created by Chung BD on 4/21/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuthUI
import FirebaseTwitterAuthUI
import SlideMenuControllerSwift

class RouteCoordinator:NSObject {
    static let share = RouteCoordinator()
    var loginVC:LoginViewController? = nil
    var mainNavigation:UINavigationController? = nil
    
}
    
//MARK: - Configuring root view controller
extension RouteCoordinator {
    func setDefaultRootViewController(withWindow window:UIWindow?){
        
        let loginVC = getLoginViewController()
        
        window?.rootViewController = loginVC
        window?.makeKeyAndVisible()
    }
    
    func getLoginViewController() -> UIViewController? {
        let mainStoryboard = UIStoryboard(name: "Login", bundle: nil)
        
        let login = mainStoryboard.instantiateInitialViewController() as? LoginViewController
        login?.authViewController = getLoginByFireBase()
        return login
    }
    
    func getLoginByFireBase() -> UIViewController {
        let providers:[FUIAuthProvider] = [
            FUITwitterAuth()
        ]
        
        let authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI?.delegate = self
        authUI?.providers = providers
        
        let authViewController = authUI!.authViewController()
        
        return authViewController
    }
    
    func getHomeCombiningSlideMenu() -> UIViewController? {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let menuStoryBoard = UIStoryboard(name: "Menu", bundle: nil)
        
        
        guard let homeVC = mainStoryBoard.instantiateInitialViewController()
        , let menuVC = menuStoryBoard.instantiateInitialViewController() else {
            return nil
        }
        
        let slideMenuController = SlideMenuController(mainViewController: homeVC, leftMenuViewController: menuVC)
         
        return slideMenuController
    }
    
    func getTabbarCombiningSlideMenu() -> UIViewController? {
    
        let storyBoard = UIStoryboard(name: "Tabbar", bundle: nil)
        let menuStoryBoard = UIStoryboard(name: "Menu", bundle: nil)
        
        guard let tabBar = storyBoard.instantiateInitialViewController(),
            let menuVC = menuStoryBoard.instantiateInitialViewController() else {
            return nil
        }

        mainNavigation = tabBar as? UINavigationController
        
        let slideMenuController = SlideMenuController(mainViewController: tabBar, leftMenuViewController: menuVC)
        
        return slideMenuController
    }
    
    func goToInputScreen(from vc:UIViewController, item:FeatureItem) {
        let storyBoard = UIStoryboard(name: "Inputs", bundle: nil)
        
        var inputViewController = UIViewController()
        
        switch item.feature {
        case .text:
            let textInput = storyBoard.instantiateViewController(withIdentifier: "TextInputViewController") as! TextInputViewController
            textInput.feature = item
            inputViewController = textInput
        case .image:
            let imageInput = storyBoard.instantiateViewController(withIdentifier: "ImageInputVC") as! ImageInputVC
            imageInput.feature = item
            inputViewController = imageInput
        case .voiceToText:
            let voiceInput = storyBoard.instantiateViewController(withIdentifier: "VoiceStreamVC") as! VoiceStreamVC
            voiceInput.feature = item
            inputViewController = voiceInput
        case .textToSpeech:
            let textToSpeech = storyBoard.instantiateViewController(withIdentifier: "TextSpeechVC") as! TextSpeechVC
            textToSpeech.feature = item
            inputViewController = textToSpeech
        }
        
        mainNavigation?.pushViewController(inputViewController, animated: true)
    }
    
    func showTimeline(from vc:UIViewController, searchQuery:String, title:String) {
        let client = TWTRAPIClient()
        let dataSource = TWTRSearchTimelineDataSource(searchQuery: searchQuery, apiClient: client)
        
        let searchTimeline =  SearchTimelineVC(dataSource: dataSource)
        searchTimeline.title = title
        searchTimeline.showTweetActions = true
        vc.navigationController?.pushViewController(searchTimeline, animated: true)
    }
    
    func signOut(fromViewcontroller vc:UIViewController) {
        vc.view.showLoading()
        do {
            try FUIAuth.defaultAuthUI()?.signOut()
            vc.view.hideLoading()
            vc.dismiss(animated: true, completion: nil)
        } catch {
            vc.view.hideLoading()
            UIManager.showErrorAlert(withViewController: vc, error: error)
        }
    }
}

extension RouteCoordinator:FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error == nil {
            if let authResult = authDataResult {
                print("Result logined. \(authResult)")
            }
            
            if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
                print("userID from Twitter. \(userID)")
            }
        
        } else {
            print("Result logined: fail ")
        }
    }

}

