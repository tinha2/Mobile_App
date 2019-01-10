//
//  ViewWithXib.swift
//  IMuzik
//
//  Created by nguyen.manh.tuanb on 21/12/2018.
//  Copyright © 2018 nguyen.manh.tuanb. All rights reserved.
//

import UIKit

class ViewWithXib: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNibView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNibView()
    }
    
    private func setupNibView() {
        let view = viewFromNibForClass()
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
    }
    
    func setupView() { }

}
