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
    
    var areButtonsActive = true
    var category = Categories.fruitsAndVegetables
    
    var numberOfStars = 3
    var correct = 0
    var randomChain: [String] = []
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstButton.layer.cornerRadius = firstButton.frame.size.height / 10
        secondButton.layer.cornerRadius = secondButton.frame.size.height / 10
        thirdButton.layer.cornerRadius = thirdButton.frame.size.height / 10
        fourthButton.layer.cornerRadius = fourthButton.frame.size.height / 10
    
        
        let objects = Constants.getAll()
        let randomNumbers = (0...objects.count-1).shuffled()
        for i in 0..<5 {
            randomChain.append(objects[randomNumbers[i]])
        }
        
        generateAnswers()
        
        firstButton.titleLabel?.numberOfLines = 2
        firstButton.titleLabel?.textAlignment = . center
        firstButton.titleLabel?.lineBreakMode = .byWordWrapping
                secondButton.titleLabel?.numberOfLines = 2
        secondButton.titleLabel?.lineBreakMode = .byWordWrapping
        secondButton.titleLabel?.textAlignment = .center
                thirdButton.titleLabel?.numberOfLines = 2
        thirdButton.titleLabel?.lineBreakMode = .byWordWrapping
        thirdButton.titleLabel?.textAlignment = .center
                fourthButton.titleLabel?.numberOfLines = 2
        fourthButton.titleLabel?.lineBreakMode = .byWordWrapping
        fourthButton.titleLabel?.textAlignment = .center
    }
    
    override func viewDidLayoutSubviews() {
        view.backgroundColor = UIColor.clear
        imageView.image = UIImage(named: object)
        VoiceAssistant.instance.playFile(name: object, overlap: true)
//        VoiceAssistant.instance.playSequence(names: ["title", object], overlap: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRandomObject(_ number: Int) -> String {
        if (correct == number) {
            return NSLocalizedString(object, comment: "")
        }
        let obj = randomChain[number]
        if obj != self.object {
            return NSLocalizedString(obj, comment: "")
        }
        
        // 4 is a next value after answers count
        return NSLocalizedString(randomChain[4], comment: "")
    }
    
    func generateAnswers() {
        correct = Int(arc4random_uniform(4))
        firstButton.setTitle(getRandomObject(0), for: .normal)
        secondButton.setTitle(getRandomObject(1), for: .normal)
        thirdButton.setTitle(getRandomObject(2), for: .normal)
        fourthButton.setTitle(getRandomObject(3), for: .normal)
    }
    
    func highlightAnswer(number: Int, revert: Bool) {
        let isCorrect = number == correct
        
        switch number {
        case 0:
            if (revert) {
                firstButton.backgroundColor = #colorLiteral(red: 0.8799175127, green: 0.8799175127, blue: 0.8799175127, alpha: 1)
                return
            }
            firstButton.backgroundColor = isCorrect ? UIColor.green : UIColor.red
        case 1:
            if (revert) {
                secondButton.backgroundColor = #colorLiteral(red: 0.8799175127, green: 0.8799175127, blue: 0.8799175127, alpha: 1)
                return
            }
            secondButton.backgroundColor = isCorrect ? UIColor.green : UIColor.red
        case 2:
            if (revert) {
                thirdButton.backgroundColor = #colorLiteral(red: 0.8799175127, green: 0.8799175127, blue: 0.8799175127, alpha: 1)
                return
            }
            thirdButton.backgroundColor = isCorrect ? UIColor.green : UIColor.red
        case 3:
            if (revert) {
                fourthButton.backgroundColor = #colorLiteral(red: 0.8799175127, green: 0.8799175127, blue: 0.8799175127, alpha: 1)
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
        delegate?.numberOfStars = numberOfStars
        delegate?.removeBlurredBackgroundView()
        delegate?.continueProcess(from: "test")
    }
    
    func animation(number: Int, counter: Int) {
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
                        self.numberOfStars -= 1
                        if (self.numberOfStars == 0) {
                            self.dismissModal()
                        }
                        self.areButtonsActive = true
                        return
                    }
                }
                self.animation(number: number, counter: counter + 1)
            }
        }
    }
    
    func animateAnswer(number: Int, counter: Int) {
        if (!areButtonsActive) {
            return
        }
        if (number != self.correct) {
//            VoiceAssistant.instance.playFile(type: Voice.oops, overlap: true)
        }
        animation(number: number, counter: counter)
        areButtonsActive = false
        
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
