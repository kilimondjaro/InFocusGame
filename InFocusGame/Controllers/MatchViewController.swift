//
//  MatchViewController.swift
//  InFocusGame
//
//  Created by Kirill Babich on 19/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController {

    weak var delegate: ModalViewControllerDelegate?
    
    var object = ""
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var objectLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objectLabel.textColor = UIColor.white
    }
    
    override func viewDidLayoutSubviews() {
        view.backgroundColor = UIColor.clear
        
        imageView.image = UIImage(named: object)
        objectLabel.text = object
        VoiceAssistant.instance.playFile(name: "match", overlap: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        delegate?.pickUpNewObject()
        delegate?.removeBlurredBackgroundView()
        VoiceAssistant.instance.stop()        
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
