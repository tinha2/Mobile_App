//
//  AvailableLocationsVC.swift
//  DeepSocial
//
//  Created by Chung BD on 8/6/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit

class AvailableLocationsVC: UIViewController {
    
    @IBOutlet weak var lblCurrentLoc: UILabel!
    @IBOutlet weak var lblNearbyLocations: UILabel!
    var curLoc:String = ""
    
    
    static func initiate() -> AvailableLocationsVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AvailableLocationsVC")
    
        return vc as! AvailableLocationsVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblCurrentLoc.text = "Current location: " + curLoc
        
        setupTitleOfNearbyLocations()
    }

    func setupTitleOfNearbyLocations() {
        let str1 = "Nearby locations "
        let str2 = "Select your location"
        
        lblNearbyLocations.text = str1 + str2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
