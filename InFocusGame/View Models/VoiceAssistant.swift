//
//  VoiceAssistant.swift
//  InFocusGame
//
//  Created by Kirill Babich on 17/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import Foundation
import AVFoundation

enum Voice {
    case noticed, oops
    func getUrl() -> String {
        switch self {
        case .noticed:
            return "noticed"
        case .oops:
            return "oops"
        }
    }
}

class VoiceAssistant {
    private var player: AVAudioPlayer?
    private var sequencePlayer: AVQueuePlayer?
    
    private init() {}
    
    static let instance = VoiceAssistant()
    
    private func loadFile(type: Voice) {
        do {
            if let url = Bundle.main.url(forResource: type.getUrl(), withExtension: "mp3") {
                player = try AVAudioPlayer(contentsOf: url)
            }
            
        } catch {
            print("Could not load \"\(type.getUrl())\" audio file")
        }
    }
    
    private func loadFile(name: String) {
        do {
            if let url = Bundle.main.url(forResource: name, withExtension: "mp3") {
                player = try AVAudioPlayer(contentsOf: url)
            }
        } catch {
            print("Could not load \"\(name)\" audio file")
        }
    }
    
    private func loadSequenceFiles(names: [String]) {
        var items: [AVPlayerItem] = []
        do {
            for name in names {
                if let url = Bundle.main.url(forResource: name, withExtension: "mp3") {
                    items.append(AVPlayerItem(url: url))
                }
            }
            
            sequencePlayer = AVQueuePlayer(items: items)
        } catch {
            print("Could not load \"\(names)\" audio files")
        }
    }
    
    
    func playFile(type: Voice) {
        
        if ((player != nil && (player?.isPlaying)!) || !UserDefaults.standard.bool(forKey: "voiceAssistant")) {
            return
        }
        
        loadFile(type: type)
        player?.play()
    }
    
    func playFile(name: String) {
        if ((player != nil && (player?.isPlaying)!) || !UserDefaults.standard.bool(forKey: "voiceAssistant")) {
            return
        }
        
        loadFile(name: name)
        player?.play()
    }
    
    func playSequence(names: [String]) {        
        if ((player != nil && (player?.isPlaying)!) || !UserDefaults.standard.bool(forKey: "voiceAssistant")) {
            return
        }
        
        loadSequenceFiles(names: names)
        sequencePlayer?.play()
    }
    
    func stop() {
        if (player != nil && (player?.isPlaying)!) {
            player?.stop()
        }
    }
}
