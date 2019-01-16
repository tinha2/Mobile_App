//
//  ViewController.swift
//  DeepSocial
//
//  Created by Chung Bui on 4/13/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class HomeViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var txtUserInput:UITextView = UITextView()
    var tbl:UITableView = UITableView()

    var userInputStr:String = ""
    let cellIdentifier:String = "cellIdentifier"
    let features:[FeatureItem] = [
        FeatureItem(feature: .text, title: "Text Analysis"),
        FeatureItem(feature: .image(nil), title: "Image Extraction"),
        FeatureItem(feature: .voiceToText, title: "Voice Synthesis"),
        FeatureItem(feature: .textToSpeech, title: "Text To Speech"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(tbl)
        
//        let nib = UINib(nibName: "UserInputCell", bundle: nil)
//        tbl.register(nib, forCellReuseIdentifier: UserInputCell.indetifier)
        
        tbl.estimatedRowHeight = 100
        tbl.rowHeight = UITableViewAutomaticDimension
        
//        tbl.estimatedSectionHeaderHeight = 40
//        tbl.sectionHeaderHeight = UITableViewAutomaticDimension
        
        tbl.tableFooterView = UIView()
        
        tbl.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tbl.dataSource = self
        tbl.delegate = self
        
        addLeftBarButtonWithImage(UIImage(named: "ic_left_menu")!.withRenderingMode(.alwaysOriginal))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        UIManager.addShawdow(to: txtUserInput)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: action UI
    @objc func touchingInside_btnCance(sender:UIButton) {
        txtUserInput.resignFirstResponder()
    }
    

    
}

extension HomeViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        let feature = features[indexPath.row]
        if let unilCell = cell {
            updateUI(cell: unilCell, withFeatureItem: feature)

            return unilCell
        } else {
            let reuseCell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            updateUI(cell: reuseCell, withFeatureItem: feature)
            return reuseCell
        }
    }
    
    func updateUI(cell:UITableViewCell,withFeatureItem item:FeatureItem) {
        cell.textLabel?.text = item.title
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.white
//
//        let lblTitle = UILabel()
//        lblTitle.text = "Main features:"
//        lblTitle.textColor = UIColor.black
//        lblTitle.font = UIFont.boldSystemFont(ofSize: 17)
//
//        headerView.addSubview(lblTitle)
//
//        lblTitle.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(20, 20, 20, 20))
//        }
//
//        return headerView
//    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Your content:"
//    }
}

extension HomeViewController:UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 60
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feature = features[indexPath.row]
        
        G_ROUTE_COORDINATOR.goToInputScreen(from: self,item: feature)
    }
}

