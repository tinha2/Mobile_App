//
//  Copyright (c) 2016 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import Firebase

import MaterialComponents.MaterialTextFields
import MaterialComponents.MaterialButtons

@objc(EmailViewController)
class EmailViewController: UIViewController {

    var cachedContent:String?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false;
        scrollView.backgroundColor = .white
        scrollView.layoutMargins = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        return scrollView
    }()
    
    let logoImageView: UIImageView = {
        let baseImage = UIImage.init(named: "logo")
        let templatedImage = baseImage?.withRenderingMode(.alwaysTemplate)
        let logoImageView = UIImageView(image: templatedImage)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        return logoImageView
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Trend AI"
        titleLabel.textColor = COLOR_MAIN
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.sizeToFit()
        return titleLabel
    }()
    
    let usernameTextField: MDCTextField = {
        let usernameTextField = MDCTextField()
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.clearButtonMode = .unlessEditing
        return usernameTextField
    }()
    
    let passwordTextField: MDCTextField = {
        let passwordTextField = MDCTextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.isSecureTextEntry = true
        return passwordTextField
    }()
    
    // Buttons
    //TODO: Add buttons
    let btnLogin: MDCRaisedButton = {
        let cancelButton = MDCRaisedButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Sign In", for: .normal)
        cancelButton.isUppercaseTitle = false
        cancelButton.backgroundColor = COLOR_MAIN
        cancelButton.addTarget(self, action: #selector(touchingInside_btnLogin(_:)), for: .touchUpInside)
        return cancelButton
    }()
    
    let btnRegister: MDCRaisedButton = {
        let nextButton = MDCRaisedButton()
        nextButton.backgroundColor = COLOR_MAIN
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Sign Up", for: .normal)
        nextButton.isUppercaseTitle = false
        nextButton.addTarget(self, action: #selector(touchingInside_btnRegister(_:)), for: .touchUpInside)
        return nextButton
    }()
    
    //TODO: Add text field controllers
    let usernameTextFieldController: MDCTextInputControllerFilled
    let passwordTextFieldController: MDCTextInputControllerFilled
    

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        //TODO: Setup text field controllers
        usernameTextFieldController = MDCTextInputControllerFilled(textInput: usernameTextField)
        passwordTextFieldController = MDCTextInputControllerFilled(textInput: passwordTextField)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        usernameTextFieldController = MDCTextInputControllerFilled(textInput: usernameTextField)
        passwordTextFieldController = MDCTextInputControllerFilled(textInput: passwordTextField)
        super.init(coder: aDecoder)
    }
    
    //MARK: - Life Cycle of VCs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign In with Email"
        navigationController?.navigationBar.topItem?.title = ""
        
        view.tintColor = COLOR_MAIN
        scrollView.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(logoImageView)
        
        //TODO: Add text fields to scroll view and setup initial state
        scrollView.addSubview(usernameTextField)
        scrollView.addSubview(passwordTextField)
        usernameTextFieldController.placeholderText = "Email"
        usernameTextField.delegate = self
        passwordTextFieldController.placeholderText = "Password"
        passwordTextField.delegate = self
        registerKeyboardNotifications()
        
        // Buttons
        //TODO: Add buttons to the scroll view
        scrollView.addSubview(btnLogin)
        scrollView.addSubview(btnRegister)
        
        logoImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(49)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(22)
        }
        
        usernameTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(22)
            make.leadingMargin.trailingMargin.equalTo(scrollView.layoutMarginsGuide)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(usernameTextField.snp.bottom).offset(8)
            make.width.equalTo(usernameTextField)
        }
        
        btnLogin.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(8)
            make.left.equalTo(passwordTextField)
         
            make.right.equalTo(btnRegister.snp.left).inset(-8)
        }
        
        btnRegister.snp.makeConstraints { (make) in
            make.top.equalTo(btnLogin)
            make.right.equalTo(passwordTextField)
            make.width.equalTo(btnLogin)
        }
        
//        emailField = ErrorTextField()
//        emailField.text = cachedContent
//        emailField.placeholder = "Email(*)"
//
//
//        emailField.validator
//            .notEmpty(message: "Not empty")
//            .email(message: "It's not a email")
//
//
//
//        passwordField = ErrorTextField()
//        passwordField.placeholder = "Password"
//        passwordField.clearButtonMode = .whileEditing
//
//        passwordField.validator
//            .notEmpty(message: "Not empty")
//            .min(length: 3, message: "At least 3 characters")
        
    
    }
    
    
    // MARK: - Functions
    
    func setEmailContent(_ content:String?)  {
        cachedContent = content
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: NSNotification.Name(rawValue: "UIKeyboardWillShowNotification"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: NSNotification.Name(rawValue: "UIKeyboardWillChangeFrameNotification"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: NSNotification.Name(rawValue: "UIKeyboardWillHideNotification"),
            object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0);
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrollView.contentInset = UIEdgeInsets.zero;
    }
    
    func verifyEmail(textField:MDCTextField,textController:MDCTextInputControllerBase) -> Bool {
        if let text = textField.text {
            if Utility.validateEmail(Email: text) {
                textController.setErrorText(nil, errorAccessibilityValue: nil)
                return true
            } else {
                textController.setErrorText("Invalid Email",
                                            errorAccessibilityValue: nil)
            }
        } else {
            textController.setErrorText("Enter a email",
                                        errorAccessibilityValue: nil)
        }
        
        return false
    }
    
    func verifyPassword(textField:MDCTextField,textController:MDCTextInputControllerBase) -> Bool {
        if let textLeng = textField.text?.count {
            if textLeng >= 3 {
                textController.setErrorText(nil, errorAccessibilityValue: nil)
                return true
            } else {
                textController.setErrorText("Password is too short",
                                            errorAccessibilityValue: nil)
            }
        } else {
            textController.setErrorText("Enter a password",
                                        errorAccessibilityValue: nil)
        }
        
        return false
    }
    
    func verifyInputs() -> Bool {
        if verifyEmail(textField: usernameTextField, textController: usernameTextFieldController) &&
            verifyPassword(textField: passwordTextField, textController: passwordTextFieldController) {
            return true
        }
        
        return false
    }

  @IBAction func touchingInside_btnLogin(_ sender: AnyObject) {
    if !verifyInputs() {
        return
    }
    
    if let email = usernameTextField.text, let password = passwordTextField.text {
      showSpinner {
        SessionManagers.signIn(withEmail: email, password: password, { (error) in
            self.hideSpinner {
                if let unilError = error {
                    switch unilError {
                        case FIBAuthError.userNotFound:
                            UIManager.showAlert(withViewController: self, content: "The email and password you entered did not match our records. Please double-check and try again")
                        case FIBAuthError.emailExistInTwitter:
                            UIManager.showAlert(withViewController: self, content: "The email was logined by Twitter. Please login by Twitter with this email again")
                        default:
                            UIManager.showErrorAlert(withViewController: self, error: unilError)
                    }
                } else {
                    RouteCoordinator.share.presentHome()
                }
            }
        })
      }
    }
  }

  @IBAction func touchingInside_btnRegister(_ sender: AnyObject) {
    if !verifyInputs() {
        return
    }

    if let email = usernameTextField.text, let password = passwordTextField.text {
        self.showSpinner {
            // [START create_user]
            SessionManagers.createUser(withUsername: email, password: password, { (error) in
                self.hideSpinner {
                    if let unilError = error {
                        self.showMessagePrompt(unilError.localizedDescription)
                    } else {
                        self.navigationController!.popViewController(animated: true)
                        RouteCoordinator.share.presentHome()
                    }
                }
            })
        }
    }
    
    }
}

// MARK: - UITextFieldDelegate
extension EmailViewController: UITextFieldDelegate {
    
    //TODO: Add basic password field validation in the textFieldShouldReturn delegate function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        
        // TextField
        if textField == passwordTextField {
            _ = verifyPassword(textField: passwordTextField, textController: passwordTextFieldController)
        }
        
        return false
    }
}
