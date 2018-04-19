//
//  HelpViewController.swift
//  InFocusGame
//
//  Created by Kirill Babich on 19/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import UIKit

protocol ModalViewControllerDelegate: class {
    func removeBlurredBackgroundView()
    var videoCapture: VideoCapture! {get set}
}

class HelpViewController: UIViewController {
    weak var delegate: ModalViewControllerDelegate?
    
    var object = ""
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        view.backgroundColor = UIColor.clear
        
        //ensure that the icon embeded in the cancel button fits in nicely
        cancelButton.imageView?.contentMode = .scaleAspectFit
        
        //add a white tint color for the Cancel button image
        let cancelImage = UIImage(named: "Cancel")
        
        let tintedCancelImage = cancelImage?.withRenderingMode(.alwaysTemplate)
        cancelButton.setImage(tintedCancelImage, for: .normal)
        cancelButton.tintColor = .white
        
        imageView.image = UIImage(named: object)
        VoiceAssistant.instance.playFile(name: object)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        delegate?.removeBlurredBackgroundView()
        VoiceAssistant.instance.stop()
        delegate?.videoCapture.start()
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
