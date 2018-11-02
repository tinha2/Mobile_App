//
//  VoiceInputVC.swift
//  DeepSocial
//
//  Created by Chung BD on 5/27/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift

let SAMPE_RATE:Int = 16000

class VoiceInputVC: InputViewController {
    var recorder: AVAudioRecorder!
    
    var player: AVAudioPlayer!
    
    @IBOutlet var recordButton: UIButton!
    
    @IBOutlet var stopButton: UIButton!
    
    @IBOutlet var playButton: UIButton!
    
    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet var processBtn: UIButton!
    
    var meterTimer: Timer!
    
    var soundFileURL: URL!
    
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setSessionPlayback()
        askForNotifications()
        checkHeadphones()
        
        stopButton.isEnabled = false
        playButton.isEnabled = false
        
        processBtn.backgroundColor = COLOR_MAIN
        processBtn.setBackgroundColor(color: UIColor.white, forState: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK:- Functions
    @objc func background(_ notification: Notification) {
        print("\(#function)")
        
    }
    
    @objc func foreground(_ notification: Notification) {
        print("\(#function)")
        
    }
    
    
    @objc func routeChange(_ notification: Notification) {
        print("\(#function)")
        
        if let userInfo = (notification as NSNotification).userInfo {
            print("routeChange \(userInfo)")
            
            //print("userInfo \(userInfo)")
            if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt {
                //print("reason \(reason)")
                switch AVAudioSessionRouteChangeReason(rawValue: reason)! {
                case AVAudioSessionRouteChangeReason.newDeviceAvailable:
                    print("NewDeviceAvailable")
                    print("did you plug in headphones?")
                    checkHeadphones()
                case AVAudioSessionRouteChangeReason.oldDeviceUnavailable:
                    print("OldDeviceUnavailable")
                    print("did you unplug headphones?")
                    checkHeadphones()
                case AVAudioSessionRouteChangeReason.categoryChange:
                    print("CategoryChange")
                case AVAudioSessionRouteChangeReason.override:
                    print("Override")
                case AVAudioSessionRouteChangeReason.wakeFromSleep:
                    print("WakeFromSleep")
                case AVAudioSessionRouteChangeReason.unknown:
                    print("Unknown")
                case AVAudioSessionRouteChangeReason.noSuitableRouteForCategory:
                    print("NoSuitableRouteForCategory")
                case AVAudioSessionRouteChangeReason.routeConfigurationChange:
                    print("RouteConfigurationChange")
                    
                }
            }
        }
    }
    
    func setSessionPlayback() {
        print("\(#function)")
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback, with: .defaultToSpeaker)
            
        } catch {
            print("could not set session category")
            print(error.localizedDescription)
        }
        
        do {
            try session.setActive(true)
        } catch {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }

    func askForNotifications() {
        print("\(#function)")
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(background(_:)),
                                               name: NSNotification.Name.UIApplicationWillResignActive,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(foreground(_:)),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(routeChange(_:)),
                                               name: NSNotification.Name.AVAudioSessionRouteChange,
                                               object: nil)
    }
    
    func checkHeadphones() {
        print("\(#function)")
        
        // check NewDeviceAvailable and OldDeviceUnavailable for them being plugged in/unplugged
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        if !currentRoute.outputs.isEmpty {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSessionPortHeadphones {
                    print("headphones are plugged in")
                    break
                } else {
                    print("headphones are unplugged")
                }
            }
        } else {
            print("checking headphones requires a connection to a device")
        }
    }
    
    func recordWithPermission(_ setup: Bool) {
        print("\(#function)")
        
        AVAudioSession.sharedInstance().requestRecordPermission {
            [unowned self] granted in
            if granted {
                
                DispatchQueue.main.async {
                    print("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    self.recorder.record()
                    
                    self.meterTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                           target: self,
                                                           selector: #selector(self.updateAudioMeter(_:)),
                                                           userInfo: nil,
                                                           repeats: true)
                }
            } else {
                print("Permission to record not granted")
            }
        }
        
        if AVAudioSession.sharedInstance().recordPermission() == .denied {
            print("permission denied")
        }
    }
    
    func setSessionPlayAndRecord() {
        print("\(#function)")
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        } catch {
            print("could not set session category")
            print(error.localizedDescription)
        }
        
        do {
            try session.setActive(true)
        } catch {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    func setupRecorder() {
        print("\(#function)")
        
        let format = DateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        let currentFileName = "recording-\(format.string(from: Date())).m4a"
        print(currentFileName)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.soundFileURL = documentsDirectory.appendingPathComponent(currentFileName)
        print("writing to soundfile url: '\(soundFileURL!)'")
        
        if FileManager.default.fileExists(atPath: soundFileURL.absoluteString) {
            // probably won't happen. want to do something about it?
            print("soundfile \(soundFileURL.absoluteString) exists")
        }
        
        let recordSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey: SAMPE_RATE,
            AVNumberOfChannelsKey: 1,
            AVSampleRateKey: SAMPE_RATE
        ]
        
        
        do {
            recorder = try AVAudioRecorder(url: soundFileURL, settings: recordSettings)
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            recorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch {
            recorder = nil
            print(error.localizedDescription)
        }
        
    }
    
    func setContinueState(for btn:UIButton) {
        
        btn.setImage(UIImage(named: "multimeda-play"), for: .normal)
    }
    
    func setPauseState(for btn:UIButton) {
        btn.setImage(UIImage(named: "multimeda-pause"), for: .normal)
    }
    
    func setAlreadyRecordState(for btn:UIButton) {
        btn.setImage(UIImage(named: "multimeda-stop-begin"), for: .normal)
    }
    
    @objc func updateAudioMeter(_ timer: Timer) {
        
        if let recorder = self.recorder {
            if recorder.isRecording {
                let min = Int(recorder.currentTime / 60)
                let sec = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60))
                let s = String(format: "%02d:%02d", min, sec)
                statusLabel.text = s
                recorder.updateMeters()
                // if you want to draw some graphics...
                //var apc0 = recorder.averagePowerForChannel(0)
                //var peak0 = recorder.peakPowerForChannel(0)
            }
        }
    }
    
    func play() {
        print("\(#function)")
        
        
        var url: URL?
        if self.recorder != nil {
            url = self.recorder.url
        } else {
            url = self.soundFileURL!
        }
        print("playing \(String(describing: url))")
        
        do {
            self.player = try AVAudioPlayer(contentsOf: url!)
//            player.numberOfChannels
            stopButton.isEnabled = true
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch {
            self.player = nil
            print(error.localizedDescription)
        }
    }
    
    func processOnVoice() {
        view.showLoading()
        
        do {
            let data = try Data(contentsOf: soundFileURL)
            let strBase64 = data.base64EncodedString(options: .endLineWithLineFeed)
                
            NLCloud.synthesiseVoice(withContent: strBase64, sampleRateHertz: SAMPE_RATE, fileExtension: "LINEAR16")
                .observeOn(MainScheduler.instance)
                .do(onNext: { _ in self.view.hideLoading() })
                .subscribe(onNext: { (response:Response) in
                    switch response {
                    case .status(_,let str, _):
                        UIManager.showAlert(withViewController: self, content: str)
                    case .data(let json):
                        let resultVC = ResultViewController.initiate(json: json, featureValue: self.feature!)
                        self.navigationController?.pushViewController(resultVC, animated: true)
                        
                    default:
                        break

                    }
                })
                .disposed(by: bag)

        } catch {
            view.hideLoading()
            UIManager.showAlert(withViewController: self, content: error.localizedDescription)
        }
    }
    
    func processOnSampleFile() {
//        if let data = getDataFromFile("youve-been-a-very-good", extensionType: "wav") {
//            print("\(#function) \(data.count)")
//
//            let strBase64 = data.base64EncodedString(options: .lineLength64Characters)
//
//            NLCloud.synthesiseVoice(withContent: strBase64, sampleRateHertz: 44_100, fileExtension: "FLAC")
//                .observeOn(MainScheduler.instance)
//                .do(onNext: { _ in self.view.hideLoading() })
//                .subscribe(onNext: { (response:Response) in
//                    switch response {
//                    case .status(_,let str, _):
//                        UIManager.showAlert(withViewController: self, content: str)
//                    case .data(let json):
//                        let resultVC = ResultViewController.initiate(json: json, featureValue: self.feature!)
//                        self.navigationController?.pushViewController(resultVC, animated: true)
//
//                        break
//                    }
//                })
//                .disposed(by: bag)
//        }
        
        let resultVC = ResultViewController.initiateForTesting(withFeature: feature!)
        self.navigationController?.pushViewController(resultVC, animated: true)

    }
    
    func showAlertForRecordVoice() {
        UIManager.showAlert(withViewController: self, content: "Need to record a voice", type: .error)
    }
    
    // MARK: - IBActions
    @IBAction func touchingInside_btnRecord(_ sender: UIButton) {
        
        print("\(#function)")
        
        if player != nil && player.isPlaying {
            print("stopping")
            player.stop()
        }
        
        if recorder == nil {
            print("recording. recorder nil")
            setPauseState(for: recordButton)
            playButton.isEnabled = false
            stopButton.isEnabled = true
            recordWithPermission(true)
            return
        }
        
        if recorder != nil && recorder.isRecording {
            print("pausing")
            recorder.pause()
            setContinueState(for: recordButton)
            
        } else {
            print("recording")
            setPauseState(for: recordButton)
            playButton.isEnabled = false
            stopButton.isEnabled = true
            //            recorder.record()
            recordWithPermission(false)
        }
    }
    
    @IBAction func touchingInside_btnStop(_ sender: UIButton) {
        
        print("\(#function)")
        
        recorder?.stop()
        player?.stop()
        
        meterTimer.invalidate()
        
        setAlreadyRecordState(for: recordButton)
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
            playButton.isEnabled = true
            stopButton.isEnabled = false
            recordButton.isEnabled = true
        } catch {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
        
        //recorder = nil
    }
    
    @IBAction func touchingInside_btnPlay(_ sender: UIButton) {
        print("\(#function)")
        
        play()
    }
    
    @IBAction func touchingInside_btnProcess(_ sender: UIButton) {
        print("\(#function)")
        if soundFileURL == nil {
            showAlertForRecordVoice()
        } else {
//            processOnSampleFile()
            processOnVoice()
        }
        
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

// MARK: AVAudioRecorderDelegate
extension VoiceInputVC: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,
                                         successfully flag: Bool) {
        
        print("\(#function)")
        
        print("finished recording \(flag)")
        stopButton.isEnabled = false
        playButton.isEnabled = true
        setAlreadyRecordState(for: recordButton)
        
        // iOS8 and later
        let alert = UIAlertController(title: "Recorder",
                                      message: "Finished Recording",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Keep", style: .default) {[unowned self] _ in
            print("keep was tapped")
            self.recorder = nil
        })
        alert.addAction(UIAlertAction(title: "Delete", style: .default) {[unowned self] _ in
            print("delete was tapped")
            self.recorder.deleteRecording()
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder,
                                          error: Error?) {
        print("\(#function)")
        
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
    
}

// MARK: AVAudioPlayerDelegate
extension VoiceInputVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("\(#function)")
        
        print("finished playing \(flag)")
        recordButton.isEnabled = true
        stopButton.isEnabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("\(#function)")
        
        if let e = error {
            print("\(e.localizedDescription)")
        }
        
    }
}
