//
//  CVLabelCell.swift
//  DeepSocial
//
//  Created by Chung BD on 5/28/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit

class CVLabelCell: UITableViewCell {
    @IBOutlet weak var prgScore: UIProgressView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    
    static var indetifier:String {
        return "CVLabelCell"
    }
    
    var labelAnnotation:CVLabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblName.textColor = COLOR_MAIN
        prgScore.progressTintColor = UIColor.green
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(withAnnotation annotation:CVLabel) {
        lblName.text = annotation.description
        prgScore.progress = Float(annotation.score)
        lblScore.text = "\(Int(annotation.score*100))%"
    }
    
    func updateUI(withDominantColor dominantColor:CVDominantColor) {
        prgScore.progressTintColor = dominantColor.color
        lblScore.text = String(format: "%3.2f %%", dominantColor.pixelFraction*100)

        lblName.backgroundColor = dominantColor.color
        lblName.textColor = UIColor.white
        
        let hexString:String = hexStringOfColor(red: dominantColor.redColor, green: dominantColor.greenColor, blue: dominantColor.blueColor)
        lblName.text = "\(hexString), RGB(\(dominantColor.redColor),\(dominantColor.greenColor),\(dominantColor.blueColor))"
    }
}
