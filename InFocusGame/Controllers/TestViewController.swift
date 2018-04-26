//
//  TestViewController.swift
//  InFocusGame
//
//  Created by Kirill Babich on 25/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    weak var delegate: ModalViewControllerDelegate?
    var object = ""
    
    var correct = 0
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        generateAnswers()
    }
    
    override func viewDidLayoutSubviews() {
        view.backgroundColor = UIColor.clear
        imageView.image = UIImage(named: object)
        nextButton.isHidden = true
//        VoiceAssistant.instance.playFile(name: "\(object)_desc", overlap: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func highlightCorrect() {
        switch correct {
        case 0:
            firstButton.backgroundColor = UIColor.green
        case 1:
            secondButton.backgroundColor = UIColor.green
        case 2:
            thirdButton.backgroundColor = UIColor.green
        case 3:
            fourthButton.backgroundColor = UIColor.green
        default:
            return
        }
    }
    
    
    func getRandomObject() -> String {
        let num = Int(arc4random_uniform(UInt32(Constants.flatObjects.count)))
        let obj = Constants.flatObjects[num]
        if obj != self.object {
            return obj
        }
        if (num == Constants.flatObjects.count - 1) {
            return Constants.flatObjects[num - 1]
        }
        return Constants.flatObjects[num + 1]
    }
    
    func generateAnswers() {
        correct = Int(arc4random_uniform(4))
        firstButton.setTitle(correct == 0 ? object : getRandomObject(), for: .normal)
        secondButton.setTitle(correct == 1 ? object : getRandomObject(), for: .normal)
        thirdButton.setTitle(correct == 2 ? object : getRandomObject(), for: .normal)
        fourthButton.setTitle(correct == 3 ? object : getRandomObject(), for: .normal)
    }
    
    @IBAction func firstButtonPressed(_ sender: UIButton) {
        nextButton.isHidden = false
        if (correct == 0) {
            firstButton.backgroundColor = UIColor.green
        }
        else {
            firstButton.backgroundColor = UIColor.red
            highlightCorrect()
        }
    }
    
    @IBAction func secondButtonPressed(_ sender: UIButton) {
        nextButton.isHidden = false
        if (correct == 1) {
            secondButton.backgroundColor = UIColor.green
        }
        else {
            secondButton.backgroundColor = UIColor.red
            highlightCorrect()
        }
    }
    
    @IBAction func thirdButtonPressed(_ sender: UIButton) {
        nextButton.isHidden = false
        if (correct == 2) {
            thirdButton.backgroundColor = UIColor.green
        }
        else {
            thirdButton.backgroundColor = UIColor.red
            highlightCorrect()
        }
    }
    
    @IBAction func fourthButtonPressed(_ sender: UIButton) {
        nextButton.isHidden = false
        if (correct == 3) {
            fourthButton.backgroundColor = UIColor.green
        }
        else {
            fourthButton.backgroundColor = UIColor.red
            highlightCorrect()
        }
    }
}
