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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        voiceAssistantSwitch.isOn = UserDefaults.standard.bool(forKey: "voiceAssistant")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func voiceAssistatChange(_ sender: UISwitch) {
        UserDefaults.standard.set(voiceAssistantSwitch.isOn, forKey: "voiceAssistant")
        
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
