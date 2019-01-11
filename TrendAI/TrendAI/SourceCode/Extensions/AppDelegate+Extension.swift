//
//  AppDelegate+Extension.swift
//  eschool
//
//  Created by nguyen.manh.tuanb on 8/7/18.
//  Copyright © 2018 nguyen.manh.tuanb. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    func setRootViewController(_ controller: UIViewController) {
        let navigation = UINavigationController(rootViewController: controller)
        navigation.isNavigationBarHidden = true
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.makeKeyAndVisible()
        }
        setUpNavigationBar(navigation)
        window?.rootViewController = navigation
    }
    
    private func setUpNavigationBar(_ navigation: UINavigationController) {
        navigation.navigationBar.topItem?.title = ""
        navigation.navigationBar.barTintColor = #colorLiteral(red: 0.2901960784, green: 0.5568627451, blue: 0.862745098, alpha: 1)
        navigation.navigationBar.tintColor = UIColor.white
        navigation.navigationBar.isTranslucent = false
        navigation.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let attributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2901960784, green: 0.5568627451, blue: 0.862745098, alpha: 1)]
        
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .highlighted)
    }
}
