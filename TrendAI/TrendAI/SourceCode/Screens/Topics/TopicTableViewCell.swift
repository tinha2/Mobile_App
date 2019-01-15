//
//  TopicTableViewCell.swift
//  TrendsAI
//
//  Created by nguyen.manh.tuanb on 09/01/2019.
//  Copyright © 2019 Nguyen Manh Tuan. All rights reserved.
//

import UIKit
import TTGTagCollectionView
import RxSwift

class TopicTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var tagView: TTGTextTagCollectionView!
    @IBOutlet weak private var spaceToBottomContraint: NSLayoutConstraint!
    @IBOutlet weak private var showMoreButton: UIButton!
    
    private(set) var disposeBag = DisposeBag()
    let showMore = PublishSubject<Int>()
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagView.manualCalculateHeight = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func setTags(_ tags: Tags, isShowFull: Bool, index: Int) {
        tagView.removeAllTags()
        self.index = index
        
        if isShowFull || tags.count <= 5 {
            tagView.addTags(tags)
            showMoreButton.isHidden = true
            spaceToBottomContraint.constant = 0
        } else {
            let shortTags = tags.chunked(into: 5).first ?? tags
            tagView.addTags(shortTags)
            showMoreButton.isHidden = false
            spaceToBottomContraint.constant = 40
        }
        
        setupRx()
        tagView.reload()
    }
    
    private func setupRx() {
        showMoreButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.showMore.onNext(self.index)
                print("self.index \(self.index)")
            })
            .disposed(by: disposeBag)
    }
}
