//
//  EntityCell.swift
//  DeepSocial
//
//  Created by Chung BD on 4/15/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit

class EntityCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSentiment: UILabel!
    @IBOutlet weak var lblMedataLink: UILabel!
    @IBOutlet weak var lblSalient: UILabel!
    
    var entity:NLEntity? = nil
    
    static var indetifier:String {
        return "EntityCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(entity:NLEntity) {
        self.entity = entity
        
        lblName.text = entity.name
        lblSentiment.text = "Setiment: Score \(entity.sentiment.score) Magnitude \(entity.sentiment.magnitude)"
        
        if let _ = entity.metadata["wikipedia_url"] as? String {
            let attributedText = NSAttributedString(string: "Wikipedia Article", attributes:
                [.underlineStyle: NSUnderlineStyle.single.rawValue,NSAttributedString.Key.foregroundColor:COLOR_MAIN])
            lblMedataLink.attributedText = attributedText
            lblMedataLink.isUserInteractionEnabled = true
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))
            lblMedataLink.addGestureRecognizer(tapGest)
        } else {
            lblMedataLink.text = ""
        }
        
        lblSalient.text = "Salient: \(entity.salience)"
    }
    
    @objc func handleTapGesture(gesture:UITapGestureRecognizer) {
        if let urlStr = entity?.metadata["wikipedia_url"] as? String,
            let url = URL(string: urlStr) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
