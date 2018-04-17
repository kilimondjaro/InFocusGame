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
    case noticed
    func getUrl() -> String {
        switch self {
        case .noticed:
            return "noticed"
        }
    }
}

class VoiceAssistant {
    private var player: AVAudioPlayer?
    
    
    private func loadFile(type: Voice) {
        let url = Bundle.main.url(forResource: type.getUrl(), withExtension: "mp3")
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            
        } catch {
            print("Could not load \"\(type.getUrl())\" audio file")
        }
    }
    
    
    func playFile(type: Voice) {
        
        if (player != nil && (player?.isPlaying)!) {
            return
        }
        
        loadFile(type: type)
        player?.play()
    }
}
