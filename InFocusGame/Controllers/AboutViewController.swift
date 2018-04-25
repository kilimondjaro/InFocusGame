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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
