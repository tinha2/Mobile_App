//
//  EntitySentiment.swift
//  DeepSocial
//
//  Created by Chung BD on 6/10/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit

class EntitySentimentCell: UITableViewCell {
    @IBOutlet weak var btnType: UIButton!
    @IBOutlet weak var lblEntity: UILabel!
    @IBOutlet weak var lblSentiment: UILabel!
    
    static var indetifier:String {
        return "EntitySentimentCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(withEntity item:NLEntity, index:Int) {
        lblEntity.textColor = .gray
        
        let partIndex:String = "\(index). "
        lblEntity.text = partIndex + item.name
        
        let titleMain:String = "Sentiment:"
        let titleScore:String = "Score"
        let titleMagnitude:String = "Magnitude"
        
        let content = "\(titleMain) \(titleScore) \(item.sentiment.score) \(titleMagnitude) \(item.sentiment.magnitude)"
        
        let fontForScoreMagnitude:UIFont = UIFont.systemFont(ofSize: 17)
        
        let attributedString = NSMutableAttributedString(string: content)
        attributedString.setColorForText(titleMain, with: COLOR_MAIN)
        attributedString.setColorForText(titleScore, with: UIColor.green)
        attributedString.setColorForText(titleMagnitude, with: UIColor.green)
        attributedString.setFontForText(titleScore, with: fontForScoreMagnitude)
        attributedString.setFontForText(titleMagnitude, with: fontForScoreMagnitude)
        
        lblSentiment.attributedText = attributedString
        
        btnType.setTitle(item.type, for: .normal)
        btnType.setBackgroundColor(color: item.color, forState: .normal)
    }
    
}
