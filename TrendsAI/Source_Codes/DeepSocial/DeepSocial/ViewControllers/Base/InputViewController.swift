//
//  InputViewController.swift
//  DeepSocial
//
//  Created by Chung BD on 5/26/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {
    
    var feature:FeatureItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = feature?.title
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
