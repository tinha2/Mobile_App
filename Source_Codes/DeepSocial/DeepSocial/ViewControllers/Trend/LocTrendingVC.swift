//
//  LocTrendingVC.swift
//  DeepSocial
//
//  Created by Chung BD on 8/5/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit

class LocTrendingVC: UIViewController {
    
    var tblTrends = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    var searchVC:UISearchController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Private functions
    func setupSubViews() {
        view.addSubview(tblTrends)
        
        //layout
        tblTrends.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
//        let resultVC = AvailableLocationsVC.initiate()
//        searchVC = UISearchController(searchResultsController: resultVC)
//        searchVC?.searchResultsUpdater = self
//        searchVC?.dimsBackgroundDuringPresentation = false
//        searchVC?.searchBar.delegate = self
//        searchVC?.searchBar.sizeToFit()
//        searchVC?.delegate = self
//        
//        if #available(iOS 11.0, *) {
//
//            navigationController?.navigationBar.isTranslucent = false
//
//            // For iOS 11 and later, we place the search bar in the navigation bar.
//            navigationController?.navigationBar.prefersLargeTitles = true
//
//            navigationItem.searchController = searchVC
//
//            // We want the search bar visible all the time.
//            navigationItem.hidesSearchBarWhenScrolling = false
//        } else {
//            // For iOS 10 and earlier, we place the search bar in the table view's header.
//            tblTrends.tableHeaderView = searchVC?.searchBar
//        }
        
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

extension LocTrendingVC:UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension LocTrendingVC:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            searchVC?.searchResultsController?.view.isHidden = false
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchVC?.searchResultsController?.view.isHidden = true
    }
}

extension LocTrendingVC:UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        print("willPresentSearchController")
        DispatchQueue.main.async { [unowned self] in
            self.searchVC?.searchResultsController?.view.isHidden = false
        }
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        print("didPresentSearchController")
        searchController.searchBar.becomeFirstResponder()
    }
}
