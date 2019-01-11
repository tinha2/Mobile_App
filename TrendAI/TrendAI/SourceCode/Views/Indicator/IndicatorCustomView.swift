//
//  IndicatorCustomView.swift
//  eschool
//
//  Created by nguyen.manh.tuanb on 8/7/18.
//  Copyright © 2018 nguyen.manh.tuanb. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

final class IndicatorCustomView: UIView {
    
    private var indicatorView: NVActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let size: CGFloat = 50
        let indicatorViewFrame = CGRect(x: (frame.width - size) / 2,
                                        y: (frame.height - size) / 2,
                                        width: size,
                                        height: size)
        indicatorView = NVActivityIndicatorView(frame: indicatorViewFrame,
                                                type: .ballSpinFadeLoader,
                                                color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                                                padding: 10)
        
        let blurView = UIView(frame: frame)
        blurView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(blurView)
        addSubview(indicatorView)
        
        backgroundColor = .clear
    }
    
    func loading(_ isLoading: Bool) {
        if isLoading {
            let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
            rootView?.addSubview(self)
            indicatorView.startAnimating()
        } else {
            indicatorView.stopAnimating()
            removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
