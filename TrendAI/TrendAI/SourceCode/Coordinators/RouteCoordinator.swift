//
//  RouteCoordinator.swift
//  DeepSocial
//
//  Created by Chung BD on 4/21/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation
import UIKit
import SideMenu
import FirebaseAuth

class RouteCoordinator:NSObject {
    static let share = RouteCoordinator()
    var loginNav:UINavigationController? = nil
    var mainNavigation:UINavigationController? = nil
    
}
    
//MARK: - Configuring root view controller
extension RouteCoordinator {
    func setDefaultRootViewController(withWindow window:UIWindow?){
        loginNav = getLoginNav()
        window?.rootViewController = loginNav
        window?.makeKeyAndVisible()
    }
    
    func getLoginViewController() -> LoginViewController? {
        let mainStoryboard = UIStoryboard(name: "Login", bundle: nil)
      
        let login = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
      
        return login
    }
  
  func getLoginNav() -> UINavigationController? {
    let mainStoryboard = UIStoryboard(name: "Login", bundle: nil)
    let loginNav = mainStoryboard.instantiateInitialViewController() as? UINavigationController
    return loginNav
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
  
  func getLoginByEmail() -> EmailViewController? {
    let mainStoryboard = UIStoryboard(name: "Login", bundle: nil)
    
    let loginByEmail = mainStoryboard.instantiateViewController(withIdentifier: "EmailViewController") as? EmailViewController
    
    return loginByEmail
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
          let firebaseAuth = Auth.auth()
          try firebaseAuth.signOut()
          
          vc.dismiss(animated: true) { [unowned self] in
              self.mainNavigation?.dismiss(animated: true, completion: nil)
          }
        } catch {
            UIManager.showErrorAlert(withViewController: vc, error: error)
        }
        vc.view.hideLoading()
    }
    
    //MARK: - Get and handle showing home
    
    func getTabbarCombiningSlideMenu() -> UIViewController? {
        let storyBoard = UIStoryboard(name: "Tabbar", bundle: nil)
        let menuStoryBoard = UIStoryboard(name: "Menu", bundle: nil)
        
        guard let tabBar = storyBoard.instantiateInitialViewController(),
            let menuVC = menuStoryBoard.instantiateInitialViewController() else {
                return nil
        }
        
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: menuVC)
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        return tabBar
    }
    
    func goToHome(from vc:UIViewController) -> Void {
        if let homeVC = G_ROUTE_COORDINATOR.getTabbarCombiningSlideMenu() as? UINavigationController {
            vc.present(homeVC, animated: true, completion: nil)
            mainNavigation = homeVC
        }
    }
  
    func presentHome() -> Void {
        if let homeVC = G_ROUTE_COORDINATOR.getTabbarCombiningSlideMenu() as? UINavigationController {
          loginNav?.present(homeVC, animated: true, completion: nil)
          mainNavigation = homeVC
        }
    }
  
    func goToEmailRegister(from login:UIViewController, email:String? = nil) -> Void {
        guard let emailLogin = getLoginByEmail() else {
          return
        }
        
        emailLogin.setEmailContent(email)
        
        login.navigationController?.pushViewController(emailLogin, animated: true)
    }
    
    //MARK: - Handling menu
    func showMenu(from vc:UIViewController) -> Void {
        vc.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
}

//extension RouteCoordinator:FUIAuthDelegate {
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
//            
//        } else {
//            print("Result logined: fail \(error.debugDescription)")
//        }
//      
//    } 
//}

