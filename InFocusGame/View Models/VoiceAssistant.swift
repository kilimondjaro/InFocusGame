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
                    let item = AVPlayerItem(url: url)
                    items.append(item)
                }
            }
            sequencePlayer = AVQueuePlayer(items: items)
        } catch {
            print("Could not load \"\(names)\" audio files")
        }
    }
    
    
    func playFile(type: Voice, overlap: Bool) {
        
        if ((player != nil && (player?.isPlaying)! && !overlap) || !UserDefaults.standard.bool(forKey: "voiceAssistant")) {
            return
        }
        
        loadFile(type: type)
        player?.numberOfLoops = 0
        player?.play()
    }
    
    func playFile(name: String, overlap: Bool) {
        if ((player != nil && (player?.isPlaying)! && !overlap) || (sequencePlayer?.currentItem != nil && !overlap) || !UserDefaults.standard.bool(forKey: "voiceAssistant")) {
            return
        }
        loadFile(name: name)
        player?.numberOfLoops = 0
        player?.play()
    }
    
//    func playFile(name: String, overlap: Bool, loop: Bool) {
//        if ((player != nil && (player?.isPlaying)! && !overlap) || (sequencePlayer?.currentItem != nil && !overlap) || !UserDefaults.standard.bool(forKey: "voiceAssistant")) {
//            return
//        }
//        loadFile(name: name)
//        player?.play()
//        if (loop) {
//            player?.numberOfLoops = -1
//        }
//    }
    
    func playSequence(names: [String], overlap: Bool) {
        if ((player != nil && (player?.isPlaying)! && !overlap) || !UserDefaults.standard.bool(forKey: "voiceAssistant")) {
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
