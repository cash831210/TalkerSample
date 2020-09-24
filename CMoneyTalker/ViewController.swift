//
//  ViewController.swift
//  CMoneyTalker
//
//  Created by Cash Chuang on 2020/9/24.
//  Copyright © 2020 Cash Chuang. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AudioTextReaderDelegate {
    
    var isPlaying = false
    
    let audioReader = AudioTextReader()
    //定義播放語音內容的速率 介於 0.0 到 1.0 之間
    var audioRate: Double = 0.5
    //可在播放特定語句時改變聲音的音調 pitchMultiplier 的允許值一般介於0.5（低音調）和2.0（高音調）之間
    var audioPitch: Double = 1
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateStepper: UIStepper!
    
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var pitchStepper: UIStepper!
    
    @IBOutlet weak var poetryTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioReader.delegate = self
        setupRateStepper()
        setupPitchStepper()
        
        
    }
    
    func setupRateStepper() {
        rateStepper.value = audioRate
        rateStepper.minimumValue = 0.0
        rateStepper.maximumValue = 1.0
        rateStepper.stepValue = 0.1
        rateStepper.autorepeat = true
        rateStepper.isContinuous = true
        rateStepper.wraps = false
    }
    
    func setupPitchStepper() {
        pitchStepper.value = audioPitch
        pitchStepper.minimumValue = 0.5
        pitchStepper.maximumValue = 2.0
        pitchStepper.stepValue = 0.1
        pitchStepper.autorepeat = true
        pitchStepper.isContinuous = true
        pitchStepper.wraps = false
    }

    @IBAction func onRateStepperChange(_ sender: UIStepper) {
        stopButtonAction(stopButton)
        let rateValue = sender.value
        audioRate = rateValue
        rateLabel.text = "速率：\(audioRate.rounding(toDecimal: 1))"
        playPauseButtonAction(playPauseButton)
    }
    @IBAction func onPitchStepperChange(_ sender: UIStepper) {
        stopButtonAction(stopButton)
        let pitchValue = sender.value
        audioPitch = pitchValue
        pitchLabel.text = "語調：\(audioPitch.rounding(toDecimal: 1))"
        playPauseButtonAction(playPauseButton)
    }
    
    //Press Play/Pause Button
    @IBAction func playPauseButtonAction(_ sender: UIButton) {
        if(isPlaying){
            //Pause
            audioReader.synthesizer.pauseSpeaking(at: .immediate)
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        } else {
            if(audioReader.synthesizer.isPaused){
                //Resume Playing
                audioReader.resumeSpeaking()
            } else {
                audioReader.startSpeaking(toRead: poetryTextView.text ?? "", rate: Float(audioRate), pitch: Float(audioPitch))
            }
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    
    //Press Stop Button
    @IBAction func stopButtonAction(_ sender: UIButton) {
        if(isPlaying){
            //Change Button Text
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            isPlaying = !isPlaying
        }
        //Stop
        audioReader.stopSpeaking()
    }
    
    //Finished Reading
    func speechDidFinish() {
        playPauseButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        isPlaying = !isPlaying
    }
    
    //Leave Page
    deinit {
        audioReader.stopSpeaking()
        playPauseButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        isPlaying = !isPlaying
    }
    @IBAction func NextStopButton(_ sender: Any) {
        audioReader.stopSpeaking()
        playPauseButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        isPlaying = !isPlaying
    }
}

extension Double {
    func rounding(toDecimal decimal: Int) -> Double {
        let numberOfDigits = pow(10.0, Double(decimal))
        return (self * numberOfDigits).rounded(.toNearestOrAwayFromZero) / numberOfDigits
    }
}


