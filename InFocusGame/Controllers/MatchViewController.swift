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
    var stars = 3
        
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var objectLabel: UILabel!
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var starsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objectLabel.textColor = UIColor.white
        nextButton.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        view.backgroundColor = UIColor.clear
        imageView.image = UIImage(named: object)
        nextButton.layer.cornerRadius = nextButton.frame.size.height / 2
        objectLabel.text = NSLocalizedString(object, comment: "")
        VoiceAssistant.instance.playFile(name: "match", overlap: true)
    }
    
    
    func animateStar(counter: Int) {
        if (counter == self.stars) {
            return
        }
        
        var star = star1!
        
        if (counter == 1) {
            star = star2!
        }
        if (counter == 2) {
            star = star3!
        }
        
        UIView.animate(withDuration: 0.7, animations: {
            star.alpha = 1
            star.frame =  star.frame.insetBy(dx: -50, dy: -50)
            star.rotate360Degrees(duration: 0.7, completionDelegate: nil)
        }){ (succeed) -> Void in
            VoiceAssistant.instance.playParallel(name: "star_\(counter + 1)", overlap: true)
            UIView.animate(withDuration: 0.7, animations: {
                star.frame = star.frame.insetBy(dx: 50, dy: 50)
                star.image = UIImage(named: "star")
            }){ (succeed) -> Void in
                self.animateStar(counter: counter + 1)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateStar(counter: 0)
        self.nextButton.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        VoiceAssistant.instance.stop()
        VoiceAssistant.instance.playFile(type: Voice.click, overlap: true)
        dismiss(animated: true, completion: nil)
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







