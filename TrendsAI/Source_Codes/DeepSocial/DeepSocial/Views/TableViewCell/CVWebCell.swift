//
//  CVWebCell.swift
//  DeepSocial
//
//  Created by Chung BD on 5/29/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit

class CVWebCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    
    var entity:CVWebEntity?
    var page:String?
    
    static var indetifier:String {
        return "CVWebCell"
    }
    
    var label:CVLabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblName.textColor = COLOR_MAIN
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(withModel label:CVWebEntity) {
        lblName.attributedText = nil
        lblName.text = label.description
        lblScore.text = "\(label.score)"
    }
    
    func updateUI(withMatchingPage page:String) {
        self.page = page
        
        lblScore.text = ""
        
        let attributedText = NSAttributedString(string: page,
                                                attributes:[.underlineStyle: NSUnderlineStyle.styleSingle.rawValue,
                                                            NSAttributedStringKey.foregroundColor:COLOR_MAIN])
        lblName.attributedText = attributedText
        lblName.isUserInteractionEnabled = true
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))
        lblName.addGestureRecognizer(tapGest)
    }
    
    @objc func handleTapGesture(gesture:UITapGestureRecognizer) {
        if let urlStr = page,
            let url = URL(string: urlStr) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
