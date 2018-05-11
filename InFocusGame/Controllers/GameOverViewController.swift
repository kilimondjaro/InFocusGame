//
//  GameOverViewController.swift
//  InFocusGame
//
//  Created by Kirill Babich on 19/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    var win = false
    var category = Categories.fruitsAndVegetables
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var againButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        againButton.layer.cornerRadius = againButton.frame.height / 2
        menuButton.layer.cornerRadius = menuButton.frame.height / 2
        statusLabel.text = NSLocalizedString("greatJob", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "startSearch" {
                if let viewController = segue.destination as? LearnViewController {
                    viewController.category = category
                }
            }
        }
    }
}
