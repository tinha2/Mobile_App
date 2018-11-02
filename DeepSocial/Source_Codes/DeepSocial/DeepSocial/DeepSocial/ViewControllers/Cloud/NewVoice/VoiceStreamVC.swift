//
// Copyright 2016 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import UIKit
import AVFoundation
import googleapis
import RxSwift

let SAMPLE_RATE = 16000

class VoiceStreamVC : InputViewController, AudioControllerDelegate {
    
    @IBOutlet weak var viewCoverText: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var audioData: NSMutableData!
    
    var bag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    AudioController.sharedInstance.delegate = self
    
    enable(button: btnStart)
    disable(button: btnStop)
  }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UIManager.addShawdow(to: viewCoverText)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.isHidden = true
        
        NLCloud.getAccessToken()
            .subscribe(onNext: { (_) in
                
            })
            .disposed(by: bag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    //MARK: - IBAction
    @IBAction func recordAudio(_ sender: NSObject) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
          try audioSession.setCategory(AVAudioSessionCategoryRecord)
        } catch {

        }
        audioData = NSMutableData()
        _ = AudioController.sharedInstance.prepare(specifiedSampleRate: SAMPLE_RATE)
        SpeechRecognitionService.sharedInstance.sampleRate = SAMPLE_RATE
        _ = AudioController.sharedInstance.start()
        
        enable(button: btnStop)
        disable(button: btnStart)
    }

    @IBAction func stopAudio(_ sender: NSObject) {
        _ = AudioController.sharedInstance.stop()
        SpeechRecognitionService.sharedInstance.stopStreaming()
        
        enable(button: btnStart)
        disable(button: btnStop)
    }

    //MARK: - Functions
    func enable(button:UIButton) {
        button.isEnabled = true
        
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundColor(color: COLOR_MAIN, forState: .normal)
        
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
    }
    
    func disable(button:UIButton) {

        button.setTitleColor(COLOR_MAIN, for: .normal)
        button.setBackgroundColor(color: UIColor.white, forState: .normal)
        
        button.layer.borderWidth = 1
        button.layer.borderColor = COLOR_MAIN.cgColor
        
        button.isEnabled = false
    }
    
    func processSampleData(_ data: Data) -> Void {
        audioData.append(data)

        // We recommend sending samples in 100ms chunks
        let chunkSize : Int /* bytes/chunk */ = Int(0.1 /* seconds/chunk */
          * Double(SAMPLE_RATE) /* samples/second */
          * 2 /* bytes/sample */);

        if (audioData.length > chunkSize) {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating();
            
        SpeechRecognitionService.sharedInstance.streamAudioData(audioData,
                                                                  completion:
            { [weak self] (response, error) in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.activityIndicator.stopAnimating()
                strongSelf.activityIndicator.isHidden = false
                
                if let error = error {
                    strongSelf.textView.text = error.localizedDescription
                } else if let response = response {
                    var finished = false
                    var output:String = ""
                    print(response)
                    for result in response.resultsArray! {
                        if let result = result as? StreamingRecognitionResult {
                            if result.isFinal {
                                finished = true
                            }
                            if let alternatives = result.alternativesArray as? [SpeechRecognitionAlternative] {
                                let bestTranscript = strongSelf.getBestTranscript(inAlternatives: alternatives)
                                output = bestTranscript
                            }
                        }
                    }
                    strongSelf.textView.text = output
                    if finished {
                        strongSelf.stopAudio(strongSelf)
                    }
                }
            })
//            print("Chung test: \(audioData.length)")
            self.audioData = NSMutableData()
        }
    }
    
    func getBestTranscript(inAlternatives array:[SpeechRecognitionAlternative]) -> String {
        var bestTranscript:String = ""
        var currentConfidence:Float = 0
        
        for alternative in array {
            if alternative.confidence > currentConfidence {
                bestTranscript = alternative.transcript
                currentConfidence = alternative.confidence
            }
        }
        
        return bestTranscript
    }
}
