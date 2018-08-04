//
//  SearchTimelineVC.swift
//  DeepSocial
//
//  Created by Chung BD on 7/29/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit

class SearchTimelineVC: TWTRTimelineViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tweetViewDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SearchTimelineVC:TWTRTweetViewDelegate {
    func tweetView(_ tweetView: TWTRTweetView, didTap url: URL) {
        // *or* Use a system webview
        let webViewController = UIViewController()
        let webView = UIWebView(frame: webViewController.view.bounds)
        webView.loadRequest(URLRequest(url: url as URL))
        webViewController.view = webView
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
}
