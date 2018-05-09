//
//  Music.swift
//  InFocusGame
//
//  Created by Kirill Babich on 09/05/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import Foundation
import AVFoundation

enum MusicTypes: String {
    case mainTheme = "main_theme"
}

class Music {
    private var player: AVAudioPlayer?
    
    private init() {}
    
    static let instance = Music()
    
    
    private func loadFile(name: MusicTypes) {
        do {
            if let url = Bundle.main.url(forResource: name.rawValue, withExtension: "mp3") {
                player = try AVAudioPlayer(contentsOf: url)
            }
        } catch {
            print("Could not load \"\(name)\" audio file")
        }
    }
    
    
    func playMusic(name: MusicTypes) {
        if ((player != nil && (player?.isPlaying)!)) {
            return
        }
        loadFile(name: name)
        player?.numberOfLoops = -1
        player?.play()
    }
    
    func stop() {
        if (player != nil && (player?.isPlaying)!) {
            player?.stop()
        }
    }
}

