//
//  DetectedTextCell.swift
//  DeepSocial
//
//  Created by Chung BD on 6/23/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit

class DetectedTextCell: UITableViewCell {
    @IBOutlet weak var txtDescription: UILabel!
    
    static var indetifier:String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateContent(withAnnotation annotation:CVTextAnnotation) {
        txtDescription.text = annotation.description
    }
}
