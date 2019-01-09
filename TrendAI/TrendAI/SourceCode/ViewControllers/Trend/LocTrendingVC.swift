//
//  LocTrendingVC.swift
//  DeepSocial
//
//  Created by Chung BD on 8/5/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class LocTrendingVC: TWBaseViewController {
    
    var tblTrends = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
    
    var searchVC:UISearchController? = nil
    
    let cellIdentifier = "cellIdentifier"
    
    let listTrending = BehaviorSubject<[TWTrend]>(value: [])
    
    let currentLocation = PublishSubject<TWLocation>()
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupSubViews()
        
        currentLocation.asObserver()
            .subscribe(onNext: { [unowned self](loc) in
    
                LocalCoordinator.share.saveCurrentLocation(loc: loc)
                
                APICoordinator.share.getTrendingsFromTwitter(geoID: loc.woeid, completion: { [weak self](trends, error) in
                    if let unNil = error {
                        switch unNil {
                        case .expire:
                            self?.isShowingSignoutDialog = true
                        default:
                            break
                        }
                    } else {
                        self?.listTrending.onNext(trends)
                    }
                })
            })
            .disposed(by: bag)
        
        currentLocation.onNext(LocalCoordinator.share.currentLocation)
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
        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(tblTrends)
        
        tblTrends.dataSource = self
        
        listTrending.asDriver(onErrorJustReturn: [])
            .drive(onNext: { [unowned self](_) in
                self.tblTrends.reloadData()
            })
            .disposed(by: bag)
        
        tblTrends.rx.itemSelected
            .asDriver()
            .drive(onNext: { [unowned self](index) in
                do {
                    let trend = try self.listTrending.value()[index.row]
                    let client = TWTRAPIClient()
                    let dataSource = TWTRSearchTimelineDataSource(searchQuery: trend.query, apiClient: client)
                    
                    let searchTimeline =  TWTRTimelineViewController(dataSource: dataSource)
                    searchTimeline.title = trend.name
                    searchTimeline.showTweetActions = true
                    self.navigationController?.pushViewController(searchTimeline, animated: true)
                } catch {
                    print("\(error.localizedDescription)")
                }
            })
            .disposed(by: bag)
        
        //layout
        tblTrends.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
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

extension LocTrendingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            return try listTrending.value().count
        } catch {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: self.cellIdentifier)
        }
        
        let element = try! listTrending.value()[indexPath.row]
        
        cell?.textLabel?.text = element.name
        if element.tweet_volume > 0 {
            cell?.detailTextLabel?.text = "\(element.displayVolume) Tweets"
        } else {
            cell?.detailTextLabel?.text = nil
        }
        
        
        return cell!
    }
}

