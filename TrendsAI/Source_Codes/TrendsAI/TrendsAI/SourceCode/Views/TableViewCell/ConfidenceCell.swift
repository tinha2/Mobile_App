//
//  ConfidenceCell.swift
//  DeepSocial
//
//  Created by Chung BD on 5/30/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit

class ConfidenceCell: UITableViewCell {
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblConfidence: UILabel!
    
    static var indetifier:String {
        return "ConfidenceCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(withContent content:String, confidence:CGFloat) {
        lblConfidence.text = "\(confidence)"
        lblContent.text = content
    }
}
