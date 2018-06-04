//
//  SettingsViewController.swift
//  InFocusGame
//
//  Created by Kirill Babich on 18/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var gameButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("settings", comment: "")
        
        gameButton.layer.cornerRadius = gameButton.frame.size.height / 2
        soundButton.layer.cornerRadius = soundButton.frame.size.height / 2
        aboutButton.layer.cornerRadius = aboutButton.frame.size.height / 2
        backButton.layer.cornerRadius = backButton.frame.size.height / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        VoiceAssistant.instance.playFile(type: Voice.click, overlap: true)
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
