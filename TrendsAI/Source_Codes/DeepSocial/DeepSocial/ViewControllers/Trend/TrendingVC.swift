//
//  TrendingVC.swift
//  DeepSocial
//
//  Created by Chung BD on 7/23/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit
import FirebaseAuth
import TTGTagCollectionView

class TrendingVC: UIViewController {

    let urlTrendingFile = Utility.getDirectory(withFileDirectory: "trending.data")
    var tagsColctView = TTGTextTagCollectionView(frame: CGRect.zero)
    var listOfTrends = [TWTrend]()
    
    var isShowingSignoutDialog = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTagsView()
        
        if let response = loadResponseStringFromFile(), !LocalCoordinator.share.isTWExpire {
            print("debug response: \(response)")
            doProcessingWhenHavingResponse(response: response)
        } else {
            sendTrendingRequest()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isShowingSignoutDialog {
            showAlertForSigningOut()
        }
        
    }
    
    func sendTrendingRequest() {
        // Do any additional setup after loading the view.
        guard let session = TWTRTwitter.sharedInstance().sessionStore.session() else {
            isShowingSignoutDialog = true
            return
        }
        
        let userID = session.userID
        let apiClient = TWTRAPIClient(userID: userID)

        let endpoint = "https://api.twitter.com/1.1/trends/place.json"

        let params = ["id": "23424977"]
        var clientError : NSError?

        let request = apiClient.urlRequest(withMethod: "GET", urlString: endpoint, parameters: params, error: &clientError)

        apiClient.sendTwitterRequest(request) { [weak self](response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(String(describing: connectionError?.localizedDescription))")
                return
            }


            self?.saveResponseStringToFile(response: data!)
            
            self?.doProcessingWhenHavingResponse(response: data!)
        }
    }
    
    func showAlertForSigningOut() {
        UIManager.showAlert(withViewController: self, content: "You must to relogin your Twitter account!") {
            RouteCoordinator.share.signOut(fromViewcontroller: self)
        }
    }
    
    func doProcessingWhenHavingResponse(response:Data) {
        do {
            if let listDic = try JSONSerialization.jsonObject(with: response, options: []) as? [CommonDic], listDic.count > 0 {
                if let listDicOfTrend = listDic[0]["trends"] as? [CommonDic] {
                    listOfTrends = TWTrend.initiate(fromArray: listDicOfTrend)
                    addModelListToTagView(list: listOfTrends)
                    LocalCoordinator.share.resetExpireTimeForRequestToTwitter()
                }
            } else {
                print("doProcessingWhenHavingResponse wrong count")
            }
        } catch {
            print("doProcessingWhenHavingResponse fail \(error.localizedDescription)")
        }
    }
    
    func saveResponseStringToFile(response:Data) {
        do {
            try response.write(to: urlTrendingFile, options: .atomic)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadResponseStringFromFile() -> Data? {
        do {
            let contentFile = try Data(contentsOf: urlTrendingFile)
            return contentFile
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func addModelListToTagView(list:[TWTrend]) {
        let config = TTGTextTagConfig()
        config.tagBackgroundColor = COLOR_MAIN
        config.tagTextFont = UIFont.systemFont(ofSize: 14)
        config.tagTextColor = UIColor.white
        
        tagsColctView.addTags(list.map { $0.name }, with: config)
    }
    
    func setupTagsView() {
        view.addSubview(tagsColctView)
        tagsColctView.delegate = self
        tagsColctView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TrendingVC:TTGTextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        print("index tap \(index)")
        let trend = listOfTrends[Int(index)]
        let client = TWTRAPIClient()
        let dataSource = TWTRSearchTimelineDataSource(searchQuery: trend.query, apiClient: client)
        
        let searchTimeline =  TWTRTimelineViewController(dataSource: dataSource)
        searchTimeline.title = trend.name
        searchTimeline.showTweetActions = true
        navigationController?.pushViewController(searchTimeline, animated: true)
    }
}
