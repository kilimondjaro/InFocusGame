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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.layer.cornerRadius = playButton.frame.size.height / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

