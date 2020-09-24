//
//  AudioTextReader.swift
//  CMoneyTalker
//
//  Created by Cash Chuang on 2020/9/24.
//  Copyright © 2020 Cash Chuang. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioTextReaderDelegate: AnyObject {
    func speechDidFinish()
}

class AudioTextReader: NSObject, AVSpeechSynthesizerDelegate {
    //語音合成器
    let synthesizer = AVSpeechSynthesizer()

    weak var delegate: AudioTextReaderDelegate!

    override init(){
        super.init()
        self.synthesizer.delegate = self
    }

    func startSpeaking(toRead: String, rate: Float, pitch: Float){
        //如果播放語音內容 需要用到 AVSpeechUtterance 類
        let utterance = AVSpeechUtterance(string: toRead)
        //定義播放的語音語種
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-TW")
        //定義播放語音內容的速率 介於 0.0 到 1.0 之間
        utterance.rate = rate
        //可在播放特定語句時改變聲音的音調 pitchMultiplier 的允許值一般介於0.5（低音調）和2.0（高音調）之間
        utterance.pitchMultiplier = pitch
        //讓語音合成器在播放下一語句之前有短暫時間暫停
//        utterance.postUtteranceDelay = 0.5
        synthesizer.speak(utterance)
    }

    func resumeSpeaking(){
        synthesizer.continueSpeaking()
    }

    func pauseSpeaking(){
        synthesizer.pauseSpeaking(at: .immediate)
    }

    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.delegate.speechDidFinish()
    }
}
