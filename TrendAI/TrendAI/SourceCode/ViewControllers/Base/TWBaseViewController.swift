//
//  TWBaseViewController.swift
//  DeepSocial
//
//  Created by Chung BD on 8/14/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit

class TWBaseViewController: UIViewController {
    
    var isShowingSignoutDialog = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isShowingSignoutDialog {
//            showAlertForSigningOut()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showAlertForSigningOut() {
        UIManager.showAlert(withViewController: self, content: "You must to relogin your Twitter account!") {
            RouteCoordinator.share.signOut(fromViewcontroller: self)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
