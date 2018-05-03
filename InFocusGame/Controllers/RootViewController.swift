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
    @IBOutlet weak var parentLabel: UILabel!
    @IBOutlet weak var parentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestures()
        
        parentLabel.text = NSLocalizedString("parentGuard", comment: "")
        
        playButton.layer.cornerRadius = playButton.frame.size.height / 2
        parentView.layer.cornerRadius = parentView.frame.size.height / 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        parentView.isHidden = false
    }
    
    func addGestures() {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleTwoFingerUp))
        gesture.direction = .up
        gesture.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(gesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideParentView))
        
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTwoFingerUp() {
        if (!parentView.isHidden) {
            performSegue(withIdentifier: "showSettingsView", sender: self)
        }
    }
    
    @objc func hideParentView() {
        if (!parentView.isHidden) {
            parentView.isHidden = true
        }
    }
}

