//
//  LoaddingView.swift
//  SohaPay
//
//  Created by tuananhtran69 on 12/28/15.
//  Copyright © 2015 Tran Anh. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    //MARK: IB properties
    @IBOutlet weak var lblTitleInProcessing: UILabel!
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    
    public  var indicatorView: UIImageView!
    
    var bgrView:UIView!
    var contentView:UIView!
    var imvLoadding:UIImageView!
    var lbMessage:UILabel!
    
    var originX:CGFloat = 10
    
    //MARK: - Init
    class func designCodeLoadingView() -> UIView {
        return Bundle(for: self).loadNibNamed("LoadingView", owner: self, options: nil)![0] as! UIView
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    override public func awakeFromNib() {
        setupContentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func initLabelShimmer() -> Void {

    }
    
    public func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(Double.pi / 180)
    }
    
    func setupContentView () {
        self.backgroundColor = UIColor.white
        lblTitleInProcessing.text = "Processing..."
        indicatorLoading.startAnimating()
    }
    
    func show() {
        self.isHidden = false
    }
    
    func hide()
    {
        self.isHidden = true
    }
}

public extension UIView {
    struct LoadingViewConstants {
        static let Tag = 1000
    }
    
    public func showLoading() {
        
        if self.viewWithTag(LoadingViewConstants.Tag) != nil {
            // If loading view is already found in current view hierachy, do nothing
            return
        }
        
        let loadingXibView = LoadingView.designCodeLoadingView()
        loadingXibView.frame = self.bounds
        loadingXibView.tag = LoadingViewConstants.Tag
        self.addSubview(loadingXibView)
        
        loadingXibView.alpha = 0

        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.7,
            options: [],
            animations: {
                loadingXibView.alpha = 1
        },
            completion: nil
        )
    }
    
    public func hideLoading() {
        
        if let loadingXibView = self.viewWithTag(LoadingViewConstants.Tag) {
            loadingXibView.alpha = 1
            
            UIView.animate(
                withDuration: 0.7,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.7,
                options: [],
                animations: {
                    loadingXibView.alpha = 0
//                    loadingXibView.transform = CGAffineTransform(scaleX: 3, y: 3)
            }, completion: { finished in
                loadingXibView.removeFromSuperview()
            })
        }
    }
}
