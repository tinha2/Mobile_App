//
//  SentimentCell.swift
//  DeepSocial
//
//  Created by Chung BD on 5/1/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit

class SentenceCell: UITableViewCell {
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblInfor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static var indetifier:String {
        return "SentenceCell"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(sentence:NLSentence, isEntireDocument:Bool = false) {
        
        if !isEntireDocument {
            lblContent.font = UIFont.systemFont(ofSize: 17)
        }
        
        lblContent.textColor = .gray
        lblContent.text = sentence.content
        
        let titleMain:String = "Sentiment:"
        let titleScore:String = "Score"
        let titleMagnitude:String = "Magnitude"
        
        let content = "\(titleMain) \(titleScore) \(sentence.sentiment.score) \(titleMagnitude) \(sentence.sentiment.score)"
        
        let fontForScoreMagnitude:UIFont = UIFont.systemFont(ofSize: 17)
        
        let attributedString = NSMutableAttributedString(string: content)
        attributedString.setColorForText(titleMain, with: COLOR_MAIN)
        attributedString.setColorForText(titleScore, with: UIColor.green)
        attributedString.setColorForText(titleMagnitude, with: UIColor.green)
        attributedString.setFontForText(titleScore, with: fontForScoreMagnitude)
        attributedString.setFontForText(titleMagnitude, with: fontForScoreMagnitude)
        
        lblInfor.attributedText = attributedString
        
    }
}
