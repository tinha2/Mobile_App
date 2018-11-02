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
    
    
    var selectedIndex: Int = 0
    
    let titleFirstSegment = "Trends"
    let titleSecondSegment = "Performances"
    let titleThirdSegment = "Technologies"

    override func viewDidLoad() {
        super.viewDidLoad()

        addLeftBarButtonWithImage(UIImage(named: "ic_left_menu")!.withRenderingMode(.alwaysOriginal))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let storyBoardMain = UIStoryboard(name: "Main", bundle: nil)
//        let storyBoardAIHome = UIStoryboard(name: "Main", bundle: nil)
        homeAITechnologies = storyBoardMain.instantiateViewController(withIdentifier: "HomeViewController")
        
//        let storyBoardProduct = UIStoryboard(name: "Main", bundle: nil)
        homePerformance = storyBoardMain.instantiateViewController(withIdentifier: "PerformancesVC")
        
//        let storyBoardTrending = UIStoryboard(name: "Main", bundle: nil)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSegmentView(view: segmentView, items: segmentItems)
        segmentView.selectedSegmentioIndex = 0
    }
    
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
        case 1:
            title = titleSecondSegment
        case 2:
            title = titleThirdSegment
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        

    }
    
    // MARK: - IBActions
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
        
        if selectedIndex == 0 {
            title = titleFirstSegment
        } else {
            title = titleSecondSegment
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
