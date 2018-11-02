//
//  TextInputViewController.swift
//  DeepSocial
//
//  Created by Chung BD on 5/23/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit
import RxSwift

class TextInputViewController: InputViewController {
    var placeHolder:String = "Please enter your content"
    
    @IBOutlet weak var txtInput: UITextView!
    @IBOutlet weak var btnUseExample: UIButton!
    @IBOutlet weak var btnUseSearch: UIButton!
    
    var accesoryView:UIView = UIView()
    var cancelButton: UIButton = UIButton()
    var sendButton: UIButton = UIButton()

    var signalForSearch = Variable<String>("")
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupInputAccessoryViewForTextView()
        
        txtInput.font = UIFont.systemFont(ofSize: 17)
        txtInput.delegate = self
        
        //
        txtInput.text = placeHolder
        
        btnUseExample.setTitleColor(COLOR_MAIN, for: .normal)
        btnUseSearch.setBackgroundColor(color: UIColor.orange, forState: .normal)
        btnUseSearch.setTitleColor(UIColor.white, for: .normal)
        
        signalForSearch
            .asObservable()
            .filter { $0.count > 0 }
            .subscribe(onNext: { (input) in
                self.requestToNLCloud(withInput: input)
            })
            .disposed(by: bag)
    }

    func requestToNLCloud(withInput input:String) {
        
        #if DEV
            let resultVC = ResultViewController.initiateForTesting(withFeature: feature!)
            self.navigationController?.pushViewController(resultVC, animated: true)
        #else
            view.showLoading()
            NLCloud.getSentimentEntities(withContent: input)
                .debug()
                .observeOn(MainScheduler.instance)
                .do(onNext: { _ in self.view.hideLoading() })
                .subscribe(onNext: { (response:Response) in
                    switch response {
                    case .status(_,let str, _):
                        UIManager.showAlert(withViewController: self, content: str)
                    case .data(let json):
                        let resultVC = ResultViewController.initiate(json: json,featureValue: self.feature!)
                        self.navigationController?.pushViewController(resultVC, animated: true)
                    default:
                        break
                    }
                })
                .disposed(by: bag)
        #endif
    }
    
    func setupInputAccessoryViewForTextView() {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 45)
        accesoryView = UIView(frame: frame)
        accesoryView.backgroundColor = UIColor.lightGray
        accesoryView.translatesAutoresizingMaskIntoConstraints = false
        txtInput.inputAccessoryView = accesoryView
        
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
        sendButton.addTarget(self, action: #selector(touchingInside_btnSearch(_:)), for: .touchUpInside)
        
        //lay out
        sendButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func touchingInside_btnCance(sender:UIButton) {
        txtInput.resignFirstResponder()
    }

    @IBAction func touchingInside_btnUseDefault(_ sender: UIButton) {
        txtInput.text = "Google, headquartered in Mountain View, unveiled the new Android phone at the Consumer Electronic Show. Sundar Pichai said in his keynote that users love their new Android phones."

    }

    @objc @IBAction func touchingInside_btnSearch(_ sender: UIButton) {
        guard let userInput = txtInput.text, userInput != placeHolder else {
            return
        }
        
        txtInput.resignFirstResponder()
        
        signalForSearch.value = userInput
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

extension TextInputViewController:UITextViewDelegate {
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
