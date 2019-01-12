//
//  TopicViewController.swift
//  TrendsAI
//
//  Created by nguyen.manh.tuanb on 09/01/2019.
//  Copyright © 2019 Nguyen Manh Tuan. All rights reserved.
//

import UIKit
import TTGTagCollectionView
import RxSwift

typealias Tags = [String]
class Topic {
    var title: String!
    var showFull: Bool = false
    var tags: Tags!
    
    init(title: String, tags: Tags) {
        self.title = title
        self.tags = tags
    }
}

class TopicViewController: BaseViewController {
    
    @IBOutlet weak private var tbView: UITableView!
    
    var topics: [Topic] = []
    
    override func setupView() {
        
        let titles = ["News", "Lifestyle", "Entertainment", "Fun",
                      "Music", "Technology", "Government & Polytics",
                      "Science", "Arts & Culture", "Nonprofits", "Sports", "Gaming"]
        
        let subSport = ["NEL", "NBA", "MLB", "Soccer", "NASCAR", "WWE", "MMA", "Golf", "Tennis", "Basketball",
                        "Track & Field", "Premeier League", "Olympics", "UFC", "MLS", "PGA", "Hockey", "Wrestling",
                        "Baseball"]
        let subNews = ["Weather", "History", "Politics", "Health", "General News", "Business & Finance", "US News",
                       "World News", "Technology", "Science"]
        let subMusic = ["Pop", "Hip-hop/Rap", "Country", "Latino Music", "R&B Soul", "Classic Rock", "Dance/electronic",
                        "Metal", "Rock/Alt", "Indie/Experimental"]
        let subEntertainment = ["Industry News", "Digital Creators", "Movies", "Music", "Television", "Pop Culture",
                                "Style", "Arts", "Books"]
        let subLifestyle = ["Parenting", "DIY & Home", "Travel", "Finess & Wellness", "Carc Culture", "Fashion & Beauty",
                                "Lifestyle Personalities", "Food"]
        let subArts = ["Design & Architecture", "Literature", "Photography", "Art", "Interesting Pictures"]
        let subGovernment = ["Gov Officials & Agencies"]
        let subGame = ["Celebrity Gamer", "Games", "Gaming News", "eSport"]
        let subNonprofits = ["Humanitarian"]
        let subFun = ["Trending", "Amazing", "Cute", "Haha", "Weird", "Holidays", "Animals", "Memes", "Humor"]
        let subScience = ["Science News", "Space News"]
        let subTechnology = ["Technology Professionals & Reporters", "Teach News"]
        
        let subTopics = [subNews, subLifestyle, subEntertainment, subFun, subMusic,
                         subTechnology, subGovernment, subScience, subArts, subNonprofits, subSport, subGame]
        
        for index in 0..<titles.count {
            let title = titles[index]
            let tag = subTopics[index]
            let topic = Topic(title: title, tags: tag)
            topics.append(topic)
        }
        
        tbView.register(TopicTableViewCell.self)
        tbView.rowHeight = UITableView.automaticDimension
        tbView.estimatedRowHeight = 100
        tbView.showsVerticalScrollIndicator = false
        tbView.tableFooterView = UIView()
        tbView.delegate = self
        tbView.dataSource = self
    }
}

extension TopicViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbView.dequeue(TopicTableViewCell.self)
        let topic = topics[indexPath.section]
        cell.setTags(topic.tags, isShowFull: topic.showFull, index: indexPath.section)
        cell.showMore
            .subscribe(onNext: { [weak self] index in
                guard let `self` = self else { return }
                self.topics[index].showFull = true
                self.tbView.reloadRows(at: [IndexPath(row: 0, section: index)], with: .none)
            })
            .disposed(by: cell.disposeBag)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        headerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let titleLabel = UILabel(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width - 20, height: 40))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        let title = topics[section].title
        titleLabel.text = title
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

