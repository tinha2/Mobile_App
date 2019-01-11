//
//  BaseViewController.swift
//  TrendsAI
//
//  Created by Nguyen Manh Tuan on 1/8/19.
//  Copyright © 2019 Nguyen Manh Tuan. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    private var blurViewControler: UIViewController?
    private var _indicatorView: IndicatorCustomView?
    var indicatorView: IndicatorCustomView {
        if _indicatorView == nil {
            _indicatorView = IndicatorCustomView(frame: UIScreen.main.bounds)
        }
        return _indicatorView!
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    internal let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupView()
        setupRx()
        setupMultiLanguage()
    }
    
    internal func setupView() {
        
    }
    
    internal func setupRx() {
        
    }
    
    internal func setupViewModel() {
        
    }
    
    internal func setupMultiLanguage() {
        
    }
    
    func showAlert(message: String,
                   title: String? = "",
                   cancel: String = "Cancel",
                   otherButtons: [String] = [],
                   action: ((String) -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        otherButtons.forEach { (title) in
            alertVC.addAction(UIAlertAction(title: title, style: .default, handler: { (alertAction) in
                action?(alertAction.title ?? "")
            }))
        }
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func addLoadingIndicator(_ indicator: ActivityIndicator) {
        indicator
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                self?.indicatorView.loading(isLoading)
            })
            .disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        Log.debug(message: self.className + "didReceiveMemoryWarning")
    }
    
    deinit {
        Log.debug(message: self.className + "deinit")
    }
}

