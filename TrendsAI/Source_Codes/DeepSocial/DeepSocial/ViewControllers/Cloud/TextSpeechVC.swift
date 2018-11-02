//
//  TextSpeechVC.swift
//  DeepSocial
//
//  Created by Chung BD on 6/9/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit
import RxSwift
import AVFoundation

class TextSpeechVC: InputViewController {
    var placeHolder:String = "Please enter your content"
    
    @IBOutlet weak var viewCoverText: UIView!
    @IBOutlet weak var txtInput: UITextView!
    @IBOutlet weak var btnProcess: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    
    let bag = DisposeBag()
    
    var audioContent:String = ""
    
    var soundFileURL: URL!
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnPlay.isEnabled = false
        
        txtInput.delegate = self
        txtInput.text = placeHolder
        
        UIManager.addShawdow(to: viewCoverText)
        
        btnProcess.backgroundColor = UIColor.orange
        btnProcess.setTitleColor(UIColor.white, for: .normal)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UIManager.addShawdow(to: viewCoverText)
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

    //MARK: - IBAction
    @IBAction func touchingUpInside_btnProcess(_ sender: NSObject) {
        
        guard let userInput = txtInput.text, userInput != placeHolder else {
            return
        }
        
        txtInput.resignFirstResponder()
        
        view.showLoading()
        NLCloud.synthesisText(withText: userInput)
            .debug()
            .observeOn(MainScheduler.instance)
            .do(onNext: { _ in self.view.hideLoading() })
            .subscribe(onNext: { (response:Response) in
                switch response {
                case .status(_,let str, _):
                    UIManager.showAlert(withViewController: self, content: str)
                case .data(let json):
                    if let content = json["audioContent"] as? String {
                        self.audioContent = content
                        self.processDataFromResponse(audioContent: content)
                    }
                default:
                    break
                }
            })
            .disposed(by: bag)

    }
    
    @IBAction func touchingUpInside_btnPlay(_ sender: NSObject) {
        playSoundFile()
    }

    
    func processDataFromResponse(audioContent:String) {
        if saveFile(withContent: audioContent) {
            playSoundFile()
            btnPlay.isEnabled = true
        }
        
    }
    
    func saveFile(withContent content:String) -> Bool {
        if let data = Data(base64Encoded: audioContent) {
            
            let format = DateFormatter()
            format.dateFormat="yyyy-MM-dd-HH-mm-ss"
            let fileName = "textToSpeech-\(format.string(from: Date())).mp3"
            print(fileName)
            
            let fileDir = Utility.getDirectory(withFileDirectory: fileName)
            
            do {
                try data.write(to: fileDir)
                self.soundFileURL = fileDir
                
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
        
        return false
    }
    
    func playSoundFile() {
        do {
            self.player = try AVAudioPlayer(contentsOf: soundFileURL)
            //            player.numberOfChannels
//            stopButton.isEnabled = true
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch {
            self.player = nil
            print(error.localizedDescription)
        }
    }
}

extension TextSpeechVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("\(#function)")
        
        print("finished playing \(flag)")
//        recordButton.isEnabled = true
//        stopButton.isEnabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("\(#function)")
        
        if let e = error {
            print("\(e.localizedDescription)")
        }
        
    }
}

extension TextSpeechVC:UITextViewDelegate {
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
