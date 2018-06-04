//
//  AboutViewController.swift
//  InFocusGame
//
//  Created by Kirill Babich on 25/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.layer.cornerRadius = backButton.frame.size.height / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        VoiceAssistant.instance.playFile(type: Voice.click, overlap: true)
    }
    
}
