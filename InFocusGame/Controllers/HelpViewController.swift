//
//  HelpViewController.swift
//  InFocusGame
//
//  Created by Kirill Babich on 19/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    weak var delegate: ModalViewControllerDelegate?
    
    var object = ""
    var playHelp = false
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var objectLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objectLabel.textColor = UIColor.white
        
        okButton.layer.cornerRadius = okButton.frame.size.height / 2
    }
    
    override func viewDidLayoutSubviews() {
        view.backgroundColor = UIColor.clear
        

        imageView.image = UIImage(named: object)
        
        objectLabel.text = NSLocalizedString(object, comment: "")
        
        if playHelp {
            VoiceAssistant.instance.playFile(name: "\(object)_desc", overlap: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        delegate?.removeBlurredBackgroundView()
        VoiceAssistant.instance.stop()
        delegate?.continueProcess(from: nil)
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
