//
//  RootViewController.swift
//  InFocusGame
//
//  Created by Kirill Babich on 16/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import UIKit
import AVFoundation

class RootViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    var bombSoundEffect: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = Bundle.main.url(forResource: "hi", withExtension: "mp3")
        do {
            bombSoundEffect = try AVAudioPlayer(contentsOf: url!)
            
        } catch {
            print("Could not load file")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playMusic(_ sender: UIButton) {
        bombSoundEffect?.play()
    }
    
}

