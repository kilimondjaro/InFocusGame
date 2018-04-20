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
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var rightAnswersLabel: UILabel!
    @IBOutlet weak var objectsDetectedLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.text = win ? "You Win!" : "Game Over"        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
