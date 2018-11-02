//
//  TabButton.swift
//  DeepSocial
//
//  Created by Chung BD on 8/24/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit

class TabButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: (bounds.height - 25), right: 5)
            titleEdgeInsets = UIEdgeInsets(top: (imageView?.frame.height)!, left: 0, bottom: 0, right: 0)
        }
    }

}
