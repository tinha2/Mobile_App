//
//  MenuViewController.swift
//  DeepSocial
//
//  Created by Chung BD on 4/22/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit
import FirebaseAuth
import RxSwift
import SnapKit
import MaterialComponents.MaterialButtons

class MenuViewController: UIViewController {

    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var providers:[ProviderInfor] = []
    
    let cellIdentifier:String = "MenuCell"
    
    let bag = DisposeBag()
    
    var menus = ["Trends", "Go Premium"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(MenuTableViewCell.self)
        providers = [
            ProviderInfor(provider: .twitter)
        ]
        
    
        // Do any additional setup after loading the view.
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = SessionManagers.shared.getCurrentUser() {
            updateProviderIntoModel(user: user)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Functions
    func updateProviderIntoArray(provider:AuthProvider,user:UserInfo) {
        providers.filter { $0.provider == provider }.forEach { $0.update(from: user) }
    }
    
    func updateProviderIntoModel(user:FIBUser) {
        
        // The user's ID, unique to the Firebase project.
        // Do NOT use this value to authenticate with your backend server,
        // if you have one. Use getTokenWithCompletion:completion: instead.
        for (_,value) in user.providerData.enumerated() {
            print("value.providerID: \(value.providerID)")
            
            if value.providerID == AuthProvider.password.rawValue {
                print(" : \(value.providerID)")
                if let userName = value.displayName {
                    lblWelcome.text = "Welcome \(userName)\nto TrendAI"
                }
            }
            
            if value.providerID == AuthProvider.twitter.rawValue {
                updateProviderIntoArray(provider: .twitter, user: value)
            }
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func touchingInside_btnSignout(_ sender: Any) {
        RouteCoordinator.share.signOut(fromViewcontroller: self)
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

extension MenuViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return providers.count
        }
        
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let provider = providers[indexPath.row]
            let reusableCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            
            if let cell = reusableCell {
                update(provider: provider, on: cell)
                return cell
            } else {
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
                cell.selectionStyle = .none
                update(provider: provider, on: cell)
                return cell
            }
        }
        
        let cell = tableView.dequeue(MenuTableViewCell.self)
        cell.bindData(title: menus[indexPath.row])
        return cell
    }
    
    func update(provider:ProviderInfor,on cell:UITableViewCell) {
        cell.textLabel?.text = provider.provider.rawValue.uppercased()
        
        if provider.isLogined {
            cell.detailTextLabel?.text = provider.userInfor?.displayName
            
            if let url = provider.userInfor?.photoURL, provider.image == nil {
                cell.imageView?.rx_setImageFromURL(url)
                    .debug()
                    .subscribe(onNext: { image in
                        provider.image = image
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    })
                    .disposed(by: bag)
            } else {
                cell.imageView?.image = provider.image
            }
        } else {
            cell.detailTextLabel?.text = "Sign in"
        }
        
    }
}

extension MenuViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let provider = providers[indexPath.row]
            
            if provider.provider.rawValue == AuthProvider.twitter.rawValue && !provider.isLogined {
                addTwitterUser()
            }
        case 1:
            didSelectMenu(indexPath.row)
        default:
            break
        }
    }
    
    private func didSelectMenu(_ index: Int) {
        switch index {
        case 0:
            shouldOpenTabComponent.onNext(.Trends)
        case 1:
            shouldOpenTabComponent.onNext(.Payment)
        case 2:
            shouldOpenTabComponent.onNext(.Topics)
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func addTwitterUser() {
        SessionManagers.addTwitterAccount(self) { (user, error) in
            if let user = user {
                self.updateProviderIntoModel(user: user)
                self.tableView.reloadData()
            } else {
                if let unilError = error {
                    switch unilError {
                    case .twitterExistByAnother:
                        UIManager.showAlert(withViewController: self, content: "The recent Twitter has already used. Please login another Twitter account!")
                    default:
                        UIManager.showErrorAlert(withViewController: self, error: unilError)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let contentView = UIView()
            
            let buttonSignOut = MDCRaisedButton()
            buttonSignOut.setTitle("Sign Out", for: .normal)
            
            buttonSignOut.setTitleColor(UIColor.white, for: .normal)
            buttonSignOut.setBackgroundColor(color: COLOR_MAIN, forState: .normal)
            buttonSignOut.addTarget(self, action: #selector(touchingInside_btnSignout(_:)), for: .touchUpInside)
            contentView.addSubview(buttonSignOut)
            buttonSignOut.snp.makeConstraints { (make) in
                make.left.top.equalToSuperview().offset(8)
                make.bottom.right.equalToSuperview().offset(-8)
            }
            
            return contentView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != 1 {
            return 0
        }
        return 50
    }
}
