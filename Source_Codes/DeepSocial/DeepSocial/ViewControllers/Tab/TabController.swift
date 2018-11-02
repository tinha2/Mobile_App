//
//  TabController.swift
//  DeepSocial
//
//  Created by Chung BD on 7/9/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit
import Segmentio

class TabController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var buttons: [UIButton]!
    
    var segmentItems:[SegmentioItem] = []
    var segmentView: Segmentio!
    
    var subViewControllers:[UIViewController]!
    var homeAITechnologies:UIViewController!
    var homePerformance:UIViewController!
    var homeTrending:UIViewController!
    var availableLocsVC:UIViewController!
    
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect.zero)
    var selectedIndex: Int = 0
    
    let titleFirstSegment = "Trends"
    let titleSecondSegment = "Performances"
    let titleThirdSegment = "Technologies"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addMenuAtLeftMenu()
        addRightSearchMenu()
        setupSearchbar()
        setupAvailableLocations()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let storyBoardMain = UIStoryboard(name: "Main", bundle: nil)
        homeAITechnologies = storyBoardMain.instantiateViewController(withIdentifier: "HomeViewController")
        
        homePerformance = storyBoardMain.instantiateViewController(withIdentifier: "PerformancesVC")
        
        homeTrending = storyBoardMain.instantiateViewController(withIdentifier: "TrendingVC")
        
        subViewControllers = [homeTrending, homePerformance, homeAITechnologies]
        
        buttons[selectedIndex].isSelected = true
        didPressTab(buttons[selectedIndex])
        
        let iconPerformance = #imageLiteral(resourceName: "ic_performance")
        let performanceItem = SegmentioItem(title: titleSecondSegment, image:iconPerformance)
        
        let iconTechnologies = #imageLiteral(resourceName: "ic_technologies")
        let technologiesItem = SegmentioItem(title: titleThirdSegment, image:iconTechnologies)
        
        let iconTrending = #imageLiteral(resourceName: "ic_trending")
        let trendingItem = SegmentioItem(title: titleFirstSegment, image:iconTrending)
        
        segmentItems = [trendingItem, performanceItem,technologiesItem]

        segmentView = initSegmentView()
        view.addSubview(segmentView)
        
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        segmentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(70)
        }
        
        contentView.snp.makeConstraints { [unowned self](make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.segmentView.snp.top)
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
        }
        
        segmentView.valueDidChange = { [unowned self](_,idx:Int) in
//            self.didPressTab(self.buttons[idx])
            self.handingTouchingOnSegmentio(atIndex: idx)
        }
        

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSegmentView(view: segmentView, items: segmentItems)
        segmentView.selectedSegmentioIndex = 0
    }
    
    
    // MARK: - Functions
    func setupSegmentView(view:Segmentio,items:[SegmentioItem]) {
        
        
        let indicatorOptions = SegmentioIndicatorOptions(type: .top, ratio: 1, height: 3, color: .orange)
        
        let horizontalSeparatorOpt = SegmentioHorizontalSeparatorOptions(type: .none, height: 0, color: .white)
        
        let verticalSeparatorOpt = SegmentioVerticalSeparatorOptions(ratio: 0.8, color: .clear)
        
        let defaultState:SegmentioState = SegmentioState(backgroundColor: UIColor.clear, titleFont: UIFont.systemFont(ofSize: 13), titleTextColor: UIColor.gray)
        
        let selectedState:SegmentioState = SegmentioState(backgroundColor: UIColor.white, titleFont: UIFont.boldSystemFont(ofSize: 13), titleTextColor: COLOR_MAIN)
        
        let states:SegmentioStates = SegmentioStates(defaultState,selectedState,SegmentioState())
        
        let options = SegmentioOptions(backgroundColor: UIColor.white,
                                       segmentPosition: .fixed(maxVisibleItems: 4),
                                       indicatorOptions: indicatorOptions,
                                       horizontalSeparatorOptions: horizontalSeparatorOpt,
                                       verticalSeparatorOptions: verticalSeparatorOpt,
                                       imageContentMode: .scaleAspectFit,
                                       labelTextAlignment: .center,
                                       segmentStates: states,
                                       animationDuration: 0.3)
        
        view.setup(content: items, style: SegmentioStyle.imageOverLabel, options: options)
    }
    
    func addMenuAtLeftMenu() {
        addLeftBarButtonWithImage(UIImage(named: "ic_left_menu")!.withRenderingMode(.alwaysOriginal))
    }
    
    func setupSearchbar() {
        searchBar.delegate = self
    }
    
    func setupAvailableLocations() {
        let availableVC = AvailableLocationsVC.initiate()
        self.availableLocsVC = availableVC
    }

    func addRightSearchMenu() {
        let image = UIImage(named: "ic_search")!.withRenderingMode(.alwaysOriginal)
        
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(touchingInside_btnRightMenu(_:)))
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
        
        let backButton: UIBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(touchingInside_btnBack(_:)))
        navigationItem.leftBarButtonItem = backButton

    }
    
    func cleanBackNavigation() {
        addMenuAtLeftMenu()
    }
    
    func showAvailableLocations() {
        addChildViewController(availableLocsVC)
        
        availableLocsVC.view.frame = view.bounds
        view.addSubview(availableLocsVC.view)
        
        availableLocsVC.didMove(toParentViewController: self)
    }
    
    func hideAvailableLocations() {
        availableLocsVC.willMove(toParentViewController: nil)
        availableLocsVC.view.removeFromSuperview()
        availableLocsVC.removeFromParentViewController()
    }
    
    func initSegmentView() -> Segmentio {
        let segmentView = Segmentio(frame: CGRect.zero)
        
        return segmentView
    }
    
    func handingTouchingOnSegmentio(atIndex idx:Int) {
        let previousIndex = selectedIndex
        
        selectedIndex = idx
        
        let previousVC = subViewControllers[previousIndex]
        
        previousVC.willMove(toParentViewController: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParentViewController()
        
        let nextVC = subViewControllers[selectedIndex]
        addChildViewController(nextVC)
        
        nextVC.view.frame = contentView.bounds
        contentView.addSubview(nextVC.view)
        
        nextVC.didMove(toParentViewController: self)
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        

    }
    
    // MARK: - IBActions
    @objc func touchingInside_btnRightMenu(_ sender:Any) -> Void {
        addSearchBarToNavigation()
        cleanRightSearchMenu()
        addBackNavigation()
        searchBar.becomeFirstResponder()
    }
    
    @objc func touchingInside_btnBack(_ sender:Any) -> Void {
        searchBar.resignFirstResponder()
        addRightSearchMenu()
        cleanBackNavigation()
        cleanSearchBar()
        hideAvailableLocations()
    }
    
    @IBAction func didPressTab(_ sender: UIButton) {
        let previousIndex = selectedIndex
        
        selectedIndex = sender.tag
        
        buttons[previousIndex].isSelected = false
        sender.isSelected = true
        
        let previousVC = subViewControllers[previousIndex]
        
        previousVC.willMove(toParentViewController: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParentViewController()
        
        let nextVC = subViewControllers[selectedIndex]
        addChildViewController(nextVC)
        
        nextVC.view.frame = contentView.bounds
        contentView.addSubview(nextVC.view)
        
        nextVC.didMove(toParentViewController: self)
        
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


extension TabController:UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        showAvailableLocations()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
}
