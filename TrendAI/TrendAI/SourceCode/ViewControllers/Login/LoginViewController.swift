//
//  LoginViewController.swift
//  DeepSocial
//
//  Created by Chung BD on 4/20/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit
import FirebaseAuth
import MaterialComponents.MaterialButtons

class LoginViewController: UIViewController {
    
    var handle:AuthStateDidChangeListenerHandle?
    var authViewController:UIViewController?
    
    @IBOutlet weak var btnTwitter: UIButton!
    
    let btnLoginWithEmail: MDCRaisedButton = {
        let nextButton = MDCRaisedButton()
        nextButton.backgroundColor = COLOR_MAIN
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Sign In with email", for: .normal)
        nextButton.isUppercaseTitle = false
        nextButton.layer.cornerRadius = 8
        nextButton.setTitleFont(UIFont.boldSystemFont(ofSize: 16), for: .normal)
        nextButton.addTarget(self, action: #selector(touchingInside_btnLoginWithEmail(_:)), for: .touchUpInside)
        nextButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 50, bottom: 15, right: 50)
        return nextButton
    }()
    
    let logoImageView: UIImageView = {
        let baseImage = UIImage.init(named: "logo")
        let templatedImage = baseImage?.withRenderingMode(.alwaysTemplate)
        let logoImageView = UIImageView(image: templatedImage)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        return logoImageView
    }()
    
    var isProcessing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.showLoading()
        
        if let user = SessionManagers.shared.getCurrentUser() {
            user.reload(completion: { [unowned self](error) in
                if let unilErr = error {
                    UIManager.showErrorAlert(withViewController: self, error: unilErr)
                    _ = SessionManagers.shared.signOut()
                } else {
                    G_ROUTE_COORDINATOR.presentHome()
                }
                self.view.hideLoading()
            })
        } else {
            view.hideLoading()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = "Sign In TrendAI"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    func initSubviews() -> Void {
        view.addSubview(btnLoginWithEmail)
        view.addSubview(logoImageView)
        
        let paddingView = UIManager.paddingView()
        view.addSubview(paddingView)
        view.sendSubviewToBack(paddingView)
        
        paddingView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                // Fallback on earlier versions
                make.top.equalTo(view.layoutMarginsGuide.snp.topMargin)
            }
            
            make.bottom.equalTo(btnTwitter.snp.top)
        }
        
        btnLoginWithEmail.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(btnTwitter.snp.bottom).offset(35)
        }
        
        logoImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(paddingView)
        }
    }
    
    func handingFlowGoingToHome() {
        if isProcessing {
          print("handingFlowGoingToHome return")
            return
        }
    
        if let user = Auth.auth().currentUser {
            user.reload(completion: { [unowned self](error) in
                if error != nil {
                    self.isProcessing = true
                    self.showAuthViewController()
                } else {
                    if user.hasTwitterProvider() {
                        self.showHomeScreen()
                    } else {
                        if let email = user.email {
                            self.showAlerToLoginByTwitter(email)
                        }
                    }
                }
            })
        } else {
            // No user is signed in.
            isProcessing = true
            self.showAuthViewController()
        }
    }
    
    func showAuthViewController() {
        if self.presentedViewController == self.authViewController {
            return
        }
        
        if let authViewController = self.authViewController {
            self.present(authViewController, animated: false, completion: nil)
        }
    }
    
    func showAlerToLoginByTwitter(_ email:String) {
        isProcessing = true
        UIManager.showAlert(withViewController: self, content: "You need to login to Twitter to use this app", type: .announcement) {
            SessionManagers.loginWithTwitter(self, { (error) in
                if let unilError = error {
                    UIManager.showErrorAlert(withViewController: self, error: unilError) {
                        self.showAlerToLoginByTwitter(email)
                    }
                } else {
                    self.showHomeScreen()
                }
            })
        }
    }
    
    func showHomeScreen() {
        G_ROUTE_COORDINATOR.goToHome(from: self)
    }
    
    // MARK: - Actions
    @objc func touchingInside_btn(_ sender:Any) -> Void {
      
    }

  @objc @IBAction func touchingInside_btnLoginWithTwitter(_ sender:Any) -> Void {
    view.showLoading()
    SessionManagers.loginWithTwitter(self) { (error) in
        self.view.hideLoading()
        
        guard let error = error else {
            self.showHomeScreen()
            return
        }
        
        switch error {
            case FIBAuthError.emailUsedByLogin(let email):
                UIManager.showAlert(withViewController: self, content: "Your email has already logined by email. Please login by password with this email!") {
                    RouteCoordinator.share.goToEmailRegister(from: self, email: email)
                }
                print("touchingInside_btnLoginWithTwitter emailUsedByLogin")
            default:
                print("touchingInside_btnLoginWithTwitter default")
                break
        }
    }
  }

  @objc @IBAction func touchingInside_btnLoginWithEmail(_ sender:Any) -> Void {
    RouteCoordinator.share.goToEmailRegister(from: self)
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
