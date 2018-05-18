//
//  SoundSettingsViewController.swift
//  InFocusGame
//
//  Created by Kirill Babich on 19/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import UIKit

class SoundSettingsViewController: UIViewController {
    @IBOutlet weak var voiceAssistantSwitch: UISwitch!
    
    @IBOutlet weak var onlyNamesSwitch: UISwitch!
    @IBOutlet weak var musicSwitch: UISwitch!
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        voiceAssistantSwitch.isOn = UserDefaults.standard.bool(forKey: "voiceAssistant")
        musicSwitch.isOn = UserDefaults.standard.bool(forKey: "music")
        onlyNamesSwitch.isOn = UserDefaults.standard.bool(forKey: "onlyNames")
        
        // Do any additional setup after loading the view.
        backButton.layer.cornerRadius = backButton.frame.size.height / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onlyNamesChange(_ sender: UISwitch) {
        UserDefaults.standard.set(onlyNamesSwitch.isOn, forKey: "onlyNames")
    }
    
    @IBAction func voiceAssistatChange(_ sender: UISwitch) {
        UserDefaults.standard.set(voiceAssistantSwitch.isOn, forKey: "voiceAssistant")
    }
    
    @IBAction func musicChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(musicSwitch.isOn, forKey: "music")
        if (musicSwitch.isOn) {
            Music.instance.playMusic(name: MusicTypes.mainTheme)
        }
        else {
            Music.instance.stop()
        }
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
