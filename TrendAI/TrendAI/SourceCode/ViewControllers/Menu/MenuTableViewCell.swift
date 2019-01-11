//
//  MenuTableViewCell.swift
//  TrendAI
//
//  Created by nguyen.manh.tuanb on 10/01/2019.
//  Copyright © 2019 Benjamin. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak private var titleLabel: UILabel!

    func bindData(title: String) {
        self.titleLabel.text = title
    }
}
