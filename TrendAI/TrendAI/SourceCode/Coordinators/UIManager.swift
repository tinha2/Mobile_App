//
//  UIManager.swift
//  SohaPay
//
//  Created by tuananhtran69 on 12/25/15.
//  Copyright © 2015 Tran Anh. All rights reserved.
//

import Foundation

public typealias CompletionNormal = ()->Void
public typealias CompletionError = (Error?)->Void

class UIManager {
    enum AlertType {
        case error
        case announcement
    }
    
    static func addShawdow(to view:UIView) {
        let layer = view.layer
        let shadowPath = UIBezierPath(rect: view.bounds)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
    }
    
    static func paddingView() -> UIView {
        let view = UIView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        
        return view
    }
    
    class func showAlert(withViewController vc:UIViewController, content:String?, type:AlertType = .announcement, completion:CompletionNormal? = nil) {
        
        var title:String = "Announcement"
        
        switch type {
        case .error:
            title = "Alert"
        default:
            break
        }
        
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
            completion?()
        })
        
        alert.addAction(okAction)
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func showErrorAlert(withViewController vc:UIViewController, error:Error, completion:CompletionNormal? = nil) {
        showAlert(withViewController: vc, content: error.localizedDescription, type: .error,completion: completion)
    }
}
