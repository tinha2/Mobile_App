//
//  UserInputCell.swift
//  DeepSocial
//
//  Created by Chung BD on 4/23/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class UserInputCell: UITableViewCell {

    static var indetifier:String {
        return "UserInputCell"
    }
    
    var placeHolder:String = "Please enter your content"
    var accesoryView:UIView = UIView()
    var cancelButton: UIButton = UIButton()
    var sampleButton: UIButton = UIButton()
    var sendButton: UIButton = UIButton()
    var txtUserInput:UITextView = UITextView()
    
    var signalForSearch = Variable<String>("")
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupInputAccessoryViewForTextView()
        
        txtUserInput.font = UIFont.systemFont(ofSize: 17)
        txtUserInput.delegate = self
        contentView.addSubview(txtUserInput)
        txtUserInput.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(130)
        }

//
        txtUserInput.text = placeHolder
        
        sampleButton.setTitleColor(COLOR_MAIN, for: .normal)
        sampleButton.setTitle("Use example", for: .normal)
        sampleButton.addTarget(self, action: #selector(touchingInside_btnUseDefault(sender:)), for: .touchUpInside)
        contentView.addSubview(sampleButton)
        sampleButton.snp.makeConstraints { (make) in
            make.left.equalTo(txtUserInput)
            make.top.equalTo(txtUserInput.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-16)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupInputAccessoryViewForTextView() {
        let frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: 45)
        accesoryView = UIView(frame: frame)
        accesoryView.backgroundColor = UIColor.lightGray
        accesoryView.translatesAutoresizingMaskIntoConstraints = false
        txtUserInput.inputAccessoryView = accesoryView
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.addTarget(self, action: #selector(touchingInside_btnCance(sender:)), for: .touchUpInside)
        cancelButton.showsTouchWhenHighlighted = true
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        accesoryView.addSubview(cancelButton)
        
        //layout
        cancelButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        
        let image = UIImage(named: "ic_search")
        sendButton.setImage(image, for: .normal)
        sendButton.showsTouchWhenHighlighted = true
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.imageView?.contentMode = .scaleAspectFit
        accesoryView.addSubview(sendButton)
        sendButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        sendButton.addTarget(self, action: #selector(touchingInside_btnSearch(sender:)), for: .touchUpInside)
        
        //lay out
        sendButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
    }
    
    //MARK: action UI
    @objc func touchingInside_btnCance(sender:UIButton) {
        txtUserInput.resignFirstResponder()
    }
    
    @objc func touchingInside_btnUseDefault(sender:UIButton) {
        txtUserInput.text = "Google, headquartered in Mountain View, unveiled the new Android phone at the Consumer Electronic Show. Sundar Pichai said in his keynote that users love their new Android phones."
//        touchingInside_btnSearch(sender: sender)
    }
    
    @objc func touchingInside_btnSearch(sender:UIButton) {
        guard let userInput = txtUserInput.text else {
            return
        }
        
        txtUserInput.resignFirstResponder()
        
        signalForSearch.value = userInput
    }
}

extension UserInputCell:UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        // for place holder
        if textView.text == placeHolder {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // for place holder
        if textView.text == "" {
            textView.text = placeHolder
        }
    }
}
