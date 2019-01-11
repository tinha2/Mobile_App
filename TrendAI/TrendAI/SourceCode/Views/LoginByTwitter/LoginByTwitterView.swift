//
//  LoaddingView.swift
//  SohaPay
//
//  Created by tuananhtran69 on 12/28/15.
//  Copyright © 2015 Tran Anh. All rights reserved.
//

import UIKit

class LoginByTwitterView: UIView {
    
    //MARK: IB properties
    @IBOutlet weak var lblTitleInProcessing: UILabel!
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    
    public  var indicatorView: UIImageView!
    var handleTouching:CompletionNormal? = nil
    var bgrView:UIView!
    var contentView:UIView!
    var imvLoadding:UIImageView!
    var lbMessage:UILabel!
    
    var originX:CGFloat = 10
    
    //MARK: - Init
    class func designCodeLoadingView() -> LoginByTwitterView {
        return Bundle(for: self).loadNibNamed("LoginByTwitter", owner: self, options: nil)![0] as! LoginByTwitterView
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
    }
  
  //MARK: - IBAaction
  @IBAction func touchingInside_btnLogin(_ sender:Any) -> Void {
    self.handleTouching?()
  }
  
}

public extension UIView {
    struct LoginByTwitterViewConstants {
        static let Tag = 1001
    }
    
  public func showLoginByTwitterView(_ completionTouching:@escaping CompletionNormal) {
    
        if self.viewWithTag(LoginByTwitterViewConstants.Tag) != nil {
            // If loading view is already found in current view hierachy, do nothing
            return
        }
        
        let loginTwitterView = LoginByTwitterView.designCodeLoadingView()
        loginTwitterView.frame = self.bounds
        loginTwitterView.tag = LoginByTwitterViewConstants.Tag
        loginTwitterView.handleTouching = completionTouching
        self.addSubview(loginTwitterView)
        
        loginTwitterView.alpha = 0

        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.7,
            options: [],
            animations: {
                loginTwitterView.alpha = 1
        },
            completion: nil
        )
    }
    
    public func hideLoginByTwitterView() {
        
        if let loginTwitterView = self.viewWithTag(LoginByTwitterViewConstants.Tag) as? LoginByTwitterView {
            loginTwitterView.alpha = 1
            
            UIView.animate(
                withDuration: 0.7,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.7,
                options: [],
                animations: {
                    loginTwitterView.alpha = 0
            }, completion: { finished in
                loginTwitterView.removeFromSuperview()
            })
            
            loginTwitterView.handleTouching = nil
        }
        
        
    }
}
