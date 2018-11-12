//
//  LocationCell.swift
//  DeepSocial
//
//  Created by Chung BD on 8/11/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit

class LocationCell: UICollectionViewCell {
    @IBOutlet weak var lblName: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)

    }
    func displayContent(name:String) {
        lblName.text = name
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
