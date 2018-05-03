//
//  TestViewController.swift
//  InFocusGame
//
//  Created by Kirill Babich on 25/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    weak var delegate: TestModalViewControllerDelegate?
    var object = ""
    
    var correct = 0
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        generateAnswers()
    }
    
    override func viewDidLayoutSubviews() {
        view.backgroundColor = UIColor.clear
        imageView.image = UIImage(named: object)
//        VoiceAssistant.instance.playFile(name: "\(object)_desc", overlap: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func highlightAnswer(number: Int, revert: Bool) {
        let isCorrect = number == correct
        
        switch number {
        case 0:
            if (revert) {
                firstButton.backgroundColor = UIColor.gray
                return
            }
            firstButton.backgroundColor = isCorrect ? UIColor.green : UIColor.red
        case 1:
            if (revert) {
                secondButton.backgroundColor = UIColor.gray
                return
            }
            secondButton.backgroundColor = isCorrect ? UIColor.green : UIColor.red
        case 2:
            if (revert) {
                thirdButton.backgroundColor = UIColor.gray
                return
            }
            thirdButton.backgroundColor = isCorrect ? UIColor.green : UIColor.red
        case 3:
            if (revert) {
                fourthButton.backgroundColor = UIColor.gray
                return
            }
            fourthButton.backgroundColor = isCorrect ? UIColor.green : UIColor.red
        default:
            return
        }
    }
    
    
    func dismissModal() {
        dismiss(animated: true, completion: nil)
        VoiceAssistant.instance.stop()
        delegate?.numberOfStars = 3
        delegate?.removeBlurredBackgroundView()
        delegate?.continueProcess(from: "test")
    }
    
    func animateAnswer(number: Int, counter: Int) {
        UIView.animate(withDuration: 0.5, animations: {
            self.highlightAnswer(number: number, revert: false)
        }){ (succeed) -> Void in
            UIView.animate(withDuration: 0.5, animations: {
                self.highlightAnswer(number: number, revert: true)
            }){ (succeed) -> Void in
                if (counter == 2) {
                    if (number == self.correct) {
                        self.dismissModal()
                    }
                    else {
                      //
                        return
                    }
                }
                self.animateAnswer(number: number, counter: counter + 1)
            }
        }
    }
    
    @IBAction func firstButtonPressed(_ sender: UIButton) {
        animateAnswer(number: 0, counter: 0)
    }
    
    @IBAction func secondButtonPressed(_ sender: UIButton) {
       animateAnswer(number: 1, counter: 0)
    }
    
    @IBAction func thirdButtonPressed(_ sender: UIButton) {
        animateAnswer(number: 2, counter: 0)
    }
    
    @IBAction func fourthButtonPressed(_ sender: UIButton) {
       animateAnswer(number: 3, counter: 0)
    }
}
