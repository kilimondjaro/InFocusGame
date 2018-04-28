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
        
    @IBOutlet weak var objectLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objectLabel.textColor = UIColor.white
        starImage.alpha = 0
        nextButton.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        view.backgroundColor = UIColor.clear
        self.starImage.frame =  self.starImage.frame.insetBy(dx: 50, dy: 50)
//        imageView.image = UIImage(named: object)
        nextButton.layer.cornerRadius = nextButton.frame.size.height / 2
        objectLabel.text = NSLocalizedString(object, comment: "")
        VoiceAssistant.instance.playFile(name: "match", overlap: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.5, animations: {
            self.starImage.alpha = 1
            self.starImage.frame =  self.starImage.frame.insetBy(dx: -80, dy: -80)
            self.starImage.rotate360Degrees(duration: 1.5, completionDelegate: nil)
        }){ (succeed) -> Void in
            self.nextButton.isHidden = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        VoiceAssistant.instance.stop()
        delegate?.removeBlurredBackgroundView()
        delegate?.continueProcess(from: "match")
    }
}

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate as! CAAnimationDelegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}







