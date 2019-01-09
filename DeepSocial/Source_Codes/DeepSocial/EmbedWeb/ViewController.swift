//
//  ViewController.swift
//  EmbedWeb
//
//  Created by Chung BD on 5/6/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class ViewController: UIViewController {

    @IBOutlet weak var barBackButton: UIBarButtonItem!
    
    @IBOutlet weak var barForwardButton: UIBarButtonItem!
    @IBOutlet weak var barReloadButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!

    var webView: WKWebView = WKWebView()
    var progressView: UIProgressView = UIProgressView()
    var isFinish: Bool = false
    var myTimer: Timer = Timer()
    var lastOffsetYInScrollView:CGFloat = 0
    var bottomConstraintOfToolbar: Constraint? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "DeepSocial"
        
        barBackButton.isEnabled = false
        barForwardButton.isEnabled = false
        
        view.addSubview(webView)
        view.addSubview(progressView)
        
        webView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.toolbar.snp.top)
        }
        
        toolbar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            self.bottomConstraintOfToolbar = make.bottom.equalToSuperview().constraint
        }
        
        progressView.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        let url = URL(string: "http://35.196.236.251/")
        let request = URLRequest(url: url!)
        webView.load(request)
        
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func hideToolBar() {
        bottomConstraintOfToolbar?.update(offset: toolbar.frame.height)
    }
    
    func showToolbar() {
        bottomConstraintOfToolbar?.update(offset:0)
    }

    @objc func timerCallback(){
        
        if webView.canGoBack {
            barBackButton.isEnabled = true
        }
        
        if webView.canGoForward {
            barForwardButton.isEnabled = true
        }
        
        if isFinish {
            if progressView.progress >= 1 {
                progressView.isHidden = true
                myTimer.invalidate()
                
            }else{
                progressView.progress += 0.1
            }
        }else{
            progressView.progress += 0.05
            if progressView.progress >= 0.95 {
                progressView.progress = 0.95
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func barBackButtonAction(sender: AnyObject) {
        if webView.canGoBack {
            webView.goBack()
        }
        
    }
    
    
    @IBAction func barForwardButtonAction(sender: AnyObject) {
        if webView.canGoForward{
            webView.goForward()
        }
    }
    
    @IBAction func barReloadButtonAction(sender: AnyObject) {
        webView.reload()
    }
}

extension ViewController:WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
        progressView.progress = 0.0
        isFinish = false
        
        myTimer = Timer.scheduledTimer(timeInterval: 0.01667, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        isFinish = true
    }
}

extension ViewController:UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastOffsetYInScrollView = scrollView.contentOffset.y
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let isHide:Bool = scrollView.contentOffset.y > lastOffsetYInScrollView
        
        if isHide {
            hideToolBar()
        } else {
            showToolbar()
        }
    }
}
