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
        
        for title in titles {
            let tags = ["UITableView", "indexPath", "TopicViewController", "extension",
                        "TopicTableViewCell", "delegate", "dataSource", "tbView", "self",
                        "count", "topics"]
            
            let random = [3,4,5,6,7,8,9,10,11].randomElement() ?? 4
            let mTags = tags.chunked(into: random).first ?? tags
            
            let topic = Topic(title: title, tags: mTags)
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

