//
//  LoginViewController.swift
//  DeepSocial
//
//  Created by Chung BD on 4/20/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit
import FirebaseUI

class LoginViewController: UIViewController {
    
    var handle:AuthStateDidChangeListenerHandle?
    var authViewController:UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
//        if Auth.auth().currentUser != nil {
//            // User is signed in.
            self.showHomeScreen()
//        } else {
//            // No user is signed in.
//            if let authViewController = authViewController {
//                self.present(authViewController, animated: false, completion: nil)
//            }
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    func showHomeScreen() {
        G_ROUTE_COORDINATOR.goToHome(from: self)
    }
    
    // MARK: - Actions

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
