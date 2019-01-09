//
//  TabController.swift
//  DeepSocial
//
//  Created by Chung BD on 7/9/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SideMenu
import SnapKit

struct SegmentItem {
    var normalImg:UIImage
    var selectedImg:UIImage
    var title:String
    
}

class TabController: UIViewController {
    
    enum State {
        case normal
        case searching
      case loginTwitter
    }
    
    @IBOutlet weak var tabContainView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var buttons: [UIButton]!
    
    var subViewControllers:[UIViewController]!
    var homeAITechnologies:UIViewController!
    var homePerformance:UIViewController!
    var homeTrending:UIViewController!
    var availableLocsVC:AvailableLocationsVC!
    
    var segmentItems:[SegmentItem] = []
    
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect.zero)
    var selectedIndex: Int = 0
    
    var titleFirstSegment = "Trends"
    let titleSecondSegment = "Performances"
    let titleThirdSegment = "Technologies"
    
    let receiveLocation = PublishSubject<TWLocation>()
    
    var state:State = .normal {
        didSet {
            switch state {
            case .loginTwitter:
                view.showLoginByTwitterView {
                    self.doAddingTwitter()
                }
                cleanRightSearchMenu()
            case .normal:
                searchBar.resignFirstResponder()
                cleanBackNavigation()
                cleanDoneNavigation()
                cleanSearchBar()
                
                addRightSearchMenu()
                addMenuAtLeftMenu()
                
                hideAvailableLocations()
                
            case .searching:
                cleanBackNavigation()
                
                addSearchBarToNavigation()
                addDoneNavigation()
                
                delayWithSeconds(0.5) { [unowned self] in
                    self.searchBar.becomeFirstResponder()
                }
                
            }
        }
    }
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addMenuAtLeftMenu()
        addRightSearchMenu()
        setupAvailableLocations()
        setupSearchbar()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        setUpTabButtoms()
        setupTite(withLocation: LocalCoordinator.share.currentLocation)
        setupInitialData()
        
        contentView.snp.makeConstraints { [unowned self](make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.tabContainView.snp.top)
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
        }
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        definesPresentationContext = true
        
        buttons[selectedIndex].isSelected = true
        didPressTab(buttons[selectedIndex])
        
        checkTwitterSession()
        SessionManager.shared.onChangedTwitterProvider = { [weak self] (value)  in
            if value {
                self?.hideLoginningTwitterView()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    
    // MARK: - Functions
    
    func checkTwitterSession() {
        if !SessionManager.shared.hasTwitterProvider() {
            state = .loginTwitter
            doAddingTwitter()
        }
    }
    
    func doAddingTwitter() {
        SessionManager.addTwitterAccount(self, { [unowned self](_, error) in
            if let unilError = error {
                switch unilError {
                case .twitterExistByAnother:
                    UIManager.showAlert(withViewController: self, content: "The recent Twitter has already used. Please login another Twitter account!")
                default:
                    UIManager.showErrorAlert(withViewController: self, error: unilError)
                }
                
            } else {
                self.hideAvailableLocations()
            }
        })
    }
    
    func hideLoginningTwitterView() {
        view.hideLoginByTwitterView()
        state = .normal
    }
    
    func addMenuAtLeftMenu() {
        let image = UIImage(named: "ic_left_menu")?.withRenderingMode(.alwaysOriginal)
        
        let leftBtn: UIBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItem.Style.plain, target: self, action: #selector(touchingInside_btnLeftMenu(_:)))
        navigationItem.leftBarButtonItem = leftBtn
    }
    
    func setupSearchbar() {
        searchBar.rx.textDidBeginEditing
            .asDriver()
            .drive(onNext: { [weak self](_) in
                self?.showAvailableLocations()
            })
            .disposed(by: bag)
        
        searchBar.rx.text.asDriver()
            .drive(availableLocsVC.obsSearchBarTextChanged)
            .disposed(by: bag)
    }
    
    func setupAvailableLocations() {
        let availableVC = AvailableLocationsVC.initiate()
        self.availableLocsVC = availableVC
        
        availableVC.selectedLocation.asDriver(onErrorJustReturn: TWLocation(dic:[:]))
            .drive(onNext: { [weak self](loc) in
                //updateTo Trending screen
                self?.setPlaceToTrend(place: loc)

                //hide choosing location
                self?.state = .normal
            })
            .disposed(by: bag)
      
        availableVC.enableAroundTrends//.distinctUntilChanged()
          .debug()
          .asObservable()
          .subscribe(onNext: { (isEnable) in
            if isEnable {
              if let userLocation = PermissionCoordinator.share.userLocation {
                APICoordinator.share.getClosestLocations(location: userLocation.coordinate, completion: { [unowned self](locs, error) in
                  if error != nil {
                    print("getClosestLocations \(String(describing: error))")
                  } else {
                    self.setPlaceToTrend(place: locs[0])
                  }
                })
              }
              
            } else {
              
            }
          })
          .disposed(by: bag)
    }
  
  func setPlaceToTrend(place:TWLocation) {
    if let trendHomeTrend = self.homeTrending as? LocTrendingVC {
      trendHomeTrend.currentLocation.onNext(place)
    }
  }
    
    func setupInitialData() {
        if selectedIndex != 0 {
            return
        }
        
        if let trendHomeTrend = self.homeTrending as? LocTrendingVC {
            trendHomeTrend.currentLocation.asDriver(onErrorJustReturn: TWLocation())
                .drive(onNext: { [unowned self](loc) in
                    self.setupTite(withLocation: loc)
                })
                .disposed(by: bag)
        }
    }
    
    func setupTite(withLocation loc:TWLocation) {
        self.titleFirstSegment = "\(loc.name) trends"
        self.title = self.titleFirstSegment
    }
    
    func setUpTabButtoms() {
        
        let storyBoardMain = UIStoryboard(name: "Main", bundle: nil)
        homeAITechnologies = storyBoardMain.instantiateViewController(withIdentifier: "HomeViewController")
        
        homePerformance = storyBoardMain.instantiateViewController(withIdentifier: "PerformancesVC")
        
        homeTrending = storyBoardMain.instantiateViewController(withIdentifier: "TrendingVC")
        
        subViewControllers = [homeTrending, homePerformance, homeAITechnologies]
        
        let iconPerformance = #imageLiteral(resourceName: "ic_performance").withRenderingMode(.alwaysOriginal)
        let selectedIconPerformance = #imageLiteral(resourceName: "ic_performance_selected").withRenderingMode(.alwaysOriginal)
        
        let performanceItem = SegmentItem(normalImg: iconPerformance, selectedImg: selectedIconPerformance, title: titleFirstSegment)        
        
//        let iconTechnologies = #imageLiteral(resourceName: "ic_technologies").withRenderingMode(.alwaysOriginal)
//        let selectedIconTechnologies = #imageLiteral(resourceName: "ic_technologies_selected").withRenderingMode(.alwaysOriginal)
//
//        let technologiesItem = SegmentItem(normalImg: iconTechnologies, selectedImg: selectedIconTechnologies, title: titleSecondSegment)
        
        segmentItems = [performanceItem]
        
        for (idx,btn) in buttons.enumerated() {
            let segmentItem = segmentItems[idx]
            btn.tintColor = UIColor.clear
            btn.setTitleColor(COLOR_MAIN, for: .selected)
            btn.setTitleColor(UIColor.lightGray, for: .normal)
            
            btn.setImage(segmentItem.selectedImg, for: .selected)
            
            btn.set(image: segmentItem.normalImg, title: segmentItem.title, titlePosition: .bottom, additionalSpacing: -10, state: .normal)
            
        }
    }

    func addRightSearchMenu() {
        let image = UIImage(named: "ic_search")!.withRenderingMode(.alwaysOriginal)
        
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItem.Style.plain, target: self, action: #selector(touchingInside_btnRightMenu(_:)))
        navigationItem.rightBarButtonItem = rightButton
        
    }
    
    func cleanRightSearchMenu() {
        navigationItem.rightBarButtonItem = nil
    }
    
    func addSearchBarToNavigation() {
        searchBar.placeholder = "Search available locations"
        
        navigationItem.titleView = searchBar
    }
    
    func cleanSearchBar() {
        navigationItem.titleView = nil
    }
    
    func addBackNavigation() {
        let image = UIImage(named: "ic_back")!.withRenderingMode(.alwaysOriginal)
        
        let backButton: UIBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItem.Style.plain, target: self, action: #selector(touchingInside_btnBack(_:)))
        navigationItem.leftBarButtonItem = backButton

    }
    
    func cleanBackNavigation() {
        navigationItem.leftBarButtonItem = nil
    }
  
  func addDoneNavigation() {
    let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(touchingInside_btnBack(_:)))
    
    navigationItem.rightBarButtonItem = doneButton
  }
  
  func cleanDoneNavigation() {
    navigationItem.rightBarButtonItem = nil
  }
    
    func showAvailableLocations() {
        addChild(availableLocsVC)
        
        availableLocsVC.view.frame = view.bounds
        view.addSubview(availableLocsVC.view)
        
        availableLocsVC.didMove(toParent: self)
    }
    
    func hideAvailableLocations() {
        availableLocsVC.willMove(toParent: nil)
        availableLocsVC.view.removeFromSuperview()
        availableLocsVC.removeFromParent()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        

    }
    
    // MARK: - IBActions
    @objc func touchingInside_btnRightMenu(_ sender:Any) -> Void {
        state = .searching
    }
    
    @objc func touchingInside_btnLeftMenu(_ sender:Any) -> Void {
        G_ROUTE_COORDINATOR.showMenu(from: self)
    }

    
    @objc func touchingInside_btnBack(_ sender:Any) -> Void {
        state = .normal
    }
    
    @IBAction func didPressTab(_ sender: UIButton) {
        let previousIndex = selectedIndex
        
        selectedIndex = sender.tag
        
        buttons[previousIndex].isSelected = false
        sender.isSelected = true
        
        let previousVC = subViewControllers[previousIndex]
        
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        let nextVC = subViewControllers[selectedIndex]
        addChild(nextVC)
        
        nextVC.view.frame = contentView.bounds
        contentView.addSubview(nextVC.view)
        
        nextVC.didMove(toParent: self)
        
        //Change title
        switch selectedIndex {
            case 0:
                title = titleFirstSegment
                addRightSearchMenu()
            case 1:
                title = titleSecondSegment
                cleanRightSearchMenu()
            case 2:
                title = titleThirdSegment
                cleanRightSearchMenu()
            default:
                break
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

extension TabController:UISideMenuNavigationControllerDelegate {
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }
    
    func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }
    
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
        checkTwitterSession()
    }
    
    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
}
