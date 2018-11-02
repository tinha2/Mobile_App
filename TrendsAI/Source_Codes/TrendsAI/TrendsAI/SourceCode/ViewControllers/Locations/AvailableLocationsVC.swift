//
//  AvailableLocationsVC.swift
//  DeepSocial
//
//  Created by Chung BD on 8/6/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AvailableLocationsVC: UIViewController {
    
    @IBOutlet weak var lblCurrentLoc: UILabel!
    @IBOutlet weak var lblNearbyLocations: UILabel!
    @IBOutlet weak var coltView: UICollectionView!
    
    let obsSearchBarTextChanged = PublishSubject<String?>()
    let selectedLocation = PublishSubject<TWLocation>()
    
    var locs:[TWLocation] = []
    var isShowingSignoutDialog = false
    
    let bag = DisposeBag()
    
    var countryLocs:[TWLocation] = []
    var filteredLocs:[TWLocation] = []
    
    static func initiate() -> AvailableLocationsVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AvailableLocationsVC")
    
        return vc as! AvailableLocationsVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
//        setupTitleOfNearbyLocations()
        setupListViewForLocations()
        
        APICoordinator.share.getAvailableLocationFromTwitter { [weak self](locations,error) in
            if let unNil = error {
                switch unNil {
                case .expire:
                    self?.isShowingSignoutDialog = true
                default:
                    break
                }
            } else {
                self?.locs = locations
                
                if let strongSelf = self {
                    strongSelf.countryLocs = strongSelf.getListOfCountry(fromLocations: locations)
                    strongSelf.filteredLocs = strongSelf.countryLocs
                }
                
                self?.refreshUIOnDataList()
            }
        }
        
//        selectedLocation.asDriver(onErrorJustReturn: TWLocation())
//            .drive(onNext: { [weak self](loc) in
//                self?.setTitleOfCurrentLocation(withLocation: loc)
//            })
//            .disposed(by: bag)
        
        obsSearchBarTextChanged.asDriver(onErrorJustReturn: "")
            .drive(onNext: { [unowned self](text) in
                if let unnil = text?.lowercased(), unnil.count > 0 {
                    self.filteredLocs = self.locs.filter { $0.name.localizedCaseInsensitiveContains(unnil) }
                } else {
                    self.filteredLocs = self.countryLocs
                }
                
                self.refreshUIOnDataList()
            })
            .disposed(by: bag)
        
//        setTitleOfCurrentLocation(withLocation:LocalCoordinator.share.currentLocation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    func setupTitleOfNearbyLocations() {
        let str1 = "Nearby locations"
        let str2 = ", select your location"
        
        lblNearbyLocations.text = str1 + str2
    }
    
    func setupListViewForLocations() {
        coltView.dataSource = self
        
        coltView.rx.itemSelected.asObservable()
            .subscribe(onNext: { [unowned self](index) in
                let location = self.filteredLocs[index.row]
                self.selectedLocation.onNext(location)
            })
            .disposed(by: bag)
        
        coltView.rx.willDisplayCell.asDriver()
            .drive(onNext: { [unowned self](cell,index) in
                let loc = self.filteredLocs[index.row]
                if let locCell = cell as? LocationCell {
                    locCell.displayContent(name: loc.name)
                }

            })
            .disposed(by: bag)
    }
    
    func setTitleOfCurrentLocation(withLocation loc:TWLocation) {
        let contentText = "Current location: " + loc.name
        
        let attributedString = NSMutableAttributedString(string: contentText)
        
        attributedString.setFontForText(loc.name, with: UIFont.systemFont(ofSize: 17, weight: .medium))
        attributedString.setColorForText(loc.name, with: COLOR_MAIN)
        
        lblCurrentLoc.attributedText = attributedString
        
        lblCurrentLoc.text = "Current location: " + loc.name
    }
    
    func getListOfCountry(fromLocations locs:[TWLocation]) -> [TWLocation] {
        
        var listOutput:[TWLocation] = []
        var world = TWLocation()
        
        let groupByCountryCode = locs.group { $0.countryCode }
        
        for (_,locs) in groupByCountryCode {
            let countries = locs.filter { $0.parentid == 1 }
            if countries.count > 0 {
                listOutput.append(countries[0])
            } else {
                let country = locs[0]
                world = country
            }
            
        }
        
        listOutput = listOutput.sorted { $0.name < $1.name }
        listOutput.insert(world, at: 0)
        
        return listOutput
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func refreshUIOnDataList() {
        self.coltView.reloadData()
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

extension AvailableLocationsVC:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredLocs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCell", for: indexPath) as! LocationCell
        
        cell.lblName.textColor = UIColor.black
        
        return cell
    }
}
