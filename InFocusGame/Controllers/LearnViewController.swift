//
//  LearnViewController.swift
//  InFocusGame
//
//  Created by Kirill Babich on 17/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import UIKit
import Vision
import CoreMedia

protocol ModalViewControllerDelegate: class {
    func removeBlurredBackgroundView()
    func continueProcess(from: String?)
}


class LearnViewController: UIViewController, LearnProcessorDelegate, ModalViewControllerDelegate {
    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var objectLabel: UIButton!
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var upperView: UIView!
    
    var category = Categories.fruitsAndVegetables
    
    var videoCapture: VideoCapture!
    var startTimes: [CFTimeInterval] = []
    var learnProcessor: LearnProcessor?
    var framesDone = 0
    var frameCapturingStartTime = CACurrentMediaTime()
    let semaphore = DispatchSemaphore(value: 2)
    
    // Objects
    var currentObject = ""
    var incorrectObject = ""
    
    // Lives
    var currentLives = 3
    var failCounter = 0
    
    // Win or Not
    var win = false
    
    // Timer
    var timer = Timer()
    var loopCounter = 0
    var seconds = 60
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        self.overlayBlurredBackgroundView(style: .dark)
        self.performSegue(withIdentifier: "showNewObject", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCamera()
        setUpInterface()
        initLearnProcessor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        VoiceAssistant.instance.stop()
        self.timer.invalidate()
        self.videoCapture.stop()
        UIApplication.shared.statusBarStyle = .default
    }
    
    // MARK: - Initialization
    
    func initLearnProcessor() {
        learnProcessor = LearnProcessor(semaphore: semaphore, category: category)
        learnProcessor?.delegate = self        
        pickUpNewObject()
    }
    
    func setUpInterface() {
        checkButton.layer.cornerRadius = checkButton.frame.size.height / 2
        checkButton.clipsToBounds = true
        
        
        let blurredBackgroundView = UIVisualEffectView()
        blurredBackgroundView.frame = view.frame
        blurredBackgroundView.effect = UIBlurEffect(style: .dark)
        videoPreview.addSubview(blurredBackgroundView)
    }
    
    func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 50
        videoCapture.setUp { success in
            if success {
                // Add the video preview into the UI.
                if let previewLayer = self.videoCapture.previewLayer {
                    self.videoPreview.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                self.videoCapture.start()
            }
        }
    }
    
    func continueProcess(from: String?) {
        if let f = from, f == "match" {
            self.currentLives = 3
            pickUpNewObject()
            self.overlayBlurredBackgroundView(style: .dark)
            self.performSegue(withIdentifier: "showNewObject", sender: self)
        }
        else {
            videoCapture.start()
        }
    }
    
    func updateTimer(timer: Timer) {
        seconds -= 1
        if (seconds == 40) {
            timer.invalidate()
            if let infoCount = Constants.objectsInfo[self.currentObject], loopCounter < infoCount {
                VoiceAssistant.instance.playFile(name: "\(self.currentObject)_info_\(loopCounter)", overlap: false)
                loopCounter += 1
                seconds = 60
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: updateTimer)
            }
        }
    }
    
    func runTimer() {
        seconds = 60
        loopCounter = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: updateTimer)
    }
    
    func objectChecked(correct: Bool, incorrectObject: String?) {
        print(correct ? "TRUE" : "FALSE")
        
        DispatchQueue.main.async {
            if (correct) {
                self.overlayBlurredBackgroundView(style: .dark)
                self.timer.invalidate()
                self.performSegue(withIdentifier: "showMatchView", sender: self)
            }
            else {
                self.failCounter += 1
                if (self.failCounter % 2 == 1) {
                    VoiceAssistant.instance.playFile(type: Voice.oops, overlap: true)
                }
                else {
                    if let incorrectObjName = incorrectObject {
                        self.incorrectObject = incorrectObjName
                        
                        self.overlayBlurredBackgroundView(style: .dark)
                        self.performSegue(withIdentifier: "showFaultInfo", sender: self)
                    }
                }
                
                if (self.failCounter % 3 == 0) {
                    // TODO - Add animation and special sound
                    
//                    VoiceAssistant.instance.playFile(type: Voice.oops, overlap: true)
//                    self.failCounter = 0
                    
                    if (self.currentLives > 0) {
                        self.currentLives -= 1
                    }
                }
            }
        }
    }
    
    func pickUpNewObject() {
        if let object = self.learnProcessor?.pickUpObjectForSearch() {
            self.timer.invalidate()
            self.objectLabel.setTitle(NSLocalizedString(object, comment: ""), for: .normal)
            self.currentObject = object
            self.failCounter = 0            
            runTimer()
            
        }
        else {
            self.win = true
            performSegue(withIdentifier: "gameOver", sender: self)
        }
        
    }

    @IBAction func skipButtonPressed(_ sender: Any) {
        pickUpNewObject()
        self.overlayBlurredBackgroundView(style: .dark)
        self.performSegue(withIdentifier: "showNewObject", sender: self)
    }
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        learnProcessor?.check()
    }
    
    @IBAction func helpButtonPressed(_ sender: UIButton) {
        self.overlayBlurredBackgroundView(style: .dark)
    }
    
    @IBAction func objectLabelPressed(_ sender: UIButton) {
        VoiceAssistant.instance.playFile(name: currentObject, overlap: true)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        VoiceAssistant.instance.playFile(type: Voice.click, overlap: true)
    }
    
    
    func overlayBlurredBackgroundView(style: UIBlurEffectStyle) {
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        
        let blurredBackgroundView = UIVisualEffectView()
        
        blurredBackgroundView.frame = view.frame
        blurredBackgroundView.effect = UIBlurEffect(style: style)
        
        view.addSubview(blurredBackgroundView)
    }
    
    func removeBlurredBackgroundView() {
        
        for subview in view.subviews {
            if subview.isKind(of: UIVisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "showNewObject" {
                if let viewController = segue.destination as? HelpViewController {
                    viewController.delegate = self
                    viewController.object = self.currentObject
                    viewController.mode = HelpMode.none
                    viewController.modalPresentationStyle = .overFullScreen
                    self.videoCapture.stop()
                    VoiceAssistant.instance.stop()
                }
            }
            if identifier == "showHelpView" {
                if let viewController = segue.destination as? HelpViewController {
                    viewController.delegate = self
                    viewController.object = self.currentObject
                    viewController.mode = HelpMode.help
                    viewController.modalPresentationStyle = .overFullScreen
                    self.videoCapture.stop()
                    VoiceAssistant.instance.stop()
                }
            }
            if identifier == "showFaultInfo" {
                if let viewController = segue.destination as? HelpViewController {
                    viewController.delegate = self
                    viewController.object = self.incorrectObject
                    viewController.mode = HelpMode.fault
                    viewController.modalPresentationStyle = .overFullScreen
                    self.videoCapture.stop()
                    VoiceAssistant.instance.stop()
                }
            }
            if identifier == "showMatchView" {
                if let viewController = segue.destination as? MatchViewController {
                    viewController.delegate = self
                    viewController.object = self.currentObject
                    viewController.stars = self.currentLives
                    viewController.modalPresentationStyle = .overFullScreen
                    self.videoCapture.stop()
                    VoiceAssistant.instance.stop()
                }
            }
            if identifier == "gameOver" {
                if let viewController = segue.destination as? GameOverViewController {
//                    viewController.win = self.win
                    viewController.category = category
                    self.videoCapture.stop()
                    VoiceAssistant.instance.stop()
                }
            }
        }
    }
    
    // MARK: - UI stuff
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        resizePreviewLayer()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = videoPreview.bounds
        
    }
}

extension LearnViewController: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        if let pixelBuffer = pixelBuffer {
            // For better throughput, perform the prediction on a background queue
            // instead of on the VideoCapture queue. We use the semaphore to block
            // the capture queue and drop frames when Core ML can't keep up.
            semaphore.wait()
            DispatchQueue.global().async {
                self.learnProcessor?.process(pixelBuffer: pixelBuffer)
            }
        }
    }
}
