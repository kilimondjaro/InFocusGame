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
    func pickUpNewObject()
    var videoCapture: VideoCapture! {get set}
}


class LearnViewController: UIViewController, LearnProcessotDelegate, ModalViewControllerDelegate {
    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var objectLabel: UIButton!
    @IBOutlet weak var life1: UIButton!
    @IBOutlet weak var life2: UIButton!
    @IBOutlet weak var life3: UIButton!
    
    
    var videoCapture: VideoCapture!
    var startTimes: [CFTimeInterval] = []
    var learnProcessor: LearnProcessor?
    var framesDone = 0
    var frameCapturingStartTime = CACurrentMediaTime()
    let semaphore = DispatchSemaphore(value: 2)
    var currentObject = ""
    var currentLives = 3
    var failCounter = 0
    var incorrectObject = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLearnProcessor()
        setUpCamera()
        setUpInterface()        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.videoCapture.stop()
    }
    
    // MARK: - Initialization
    
    func initLearnProcessor() {
        learnProcessor = LearnProcessor(semaphore: semaphore)
        learnProcessor?.delegate = self
        let object = learnProcessor?.pickUpObjectForSearch()
        currentObject = object!
        self.objectLabel.setTitle(object, for: UIControlState.normal)
    }
    
    func setUpInterface() {
        checkButton.layer.cornerRadius = checkButton.frame.size.height / 2
        checkButton.clipsToBounds = true
        life1.setImage(UIImage(named: "heart"), for: UIControlState.normal)
        life2.setImage(UIImage(named: "heart"), for: UIControlState.normal)
        life3.setImage(UIImage(named: "heart"), for: UIControlState.normal)
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
    
    func objectChecked(correct: Bool, incorrectObject: String?) {
        print(correct ? "TRUE" : "FALSE")
        
        DispatchQueue.main.async {
            if (correct) {
                self.overlayBlurredBackgroundView(style: .light)
                self.performSegue(withIdentifier: "showMatchView", sender: self)
            }
            else {
                self.failCounter += 1
                if let incorrectObjName = incorrectObject, self.failCounter == 2 {
                    self.incorrectObject = incorrectObjName
                    
                    self.overlayBlurredBackgroundView(style: .dark)
                    self.performSegue(withIdentifier: "showFaultInfo", sender: self)
                }
                if (self.failCounter == 3) {
                    self.failCounter = 0
                    self.currentLives -= 1
                    if (self.currentLives == 0) {
                        self.performSegue(withIdentifier: "gameOver", sender: self)
                    }
                    else {
                        switch self.currentLives {
                        case 0:
                            self.life3.setImage(UIImage(named: "grey_heart"), for: UIControlState.normal)
                        case 1:
                            self.life2.setImage(UIImage(named: "grey_heart"), for: UIControlState.normal)
                        case 2:
                            self.life1.setImage(UIImage(named: "grey_heart"), for: UIControlState.normal)
                        default:
                            return
                        }
                    }
                }
            }
        }
    }
    
    func pickUpNewObject() {
        let object = self.learnProcessor?.pickUpObjectForSearch()
        self.objectLabel.setTitle(object, for: UIControlState.normal)
        self.currentObject = object!
        self.failCounter = 0
        VoiceAssistant.instance.playSequence(names: ["find", self.currentObject])
    }
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        learnProcessor?.check()
    }
    
    @IBAction func helpButtonPressed(_ sender: UIButton) {
        self.overlayBlurredBackgroundView(style: .dark)
    }
    
    @IBAction func objectLabelPressed(_ sender: UIButton) {
        VoiceAssistant.instance.playFile(name: currentObject)        
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
            if identifier == "showHelpView" {
                if let viewController = segue.destination as? HelpViewController {
                    viewController.delegate = self
                    viewController.object = self.currentObject
                    viewController.modalPresentationStyle = .overFullScreen
                    self.videoCapture.stop()
                    VoiceAssistant.instance.stop()
                }
            }
            if identifier == "showFaultInfo" {
                if let viewController = segue.destination as? FaultInfoViewController {
                    viewController.delegate = self
                    viewController.correctObject = self.currentObject
                    viewController.incorrectObject = self.incorrectObject
                    viewController.modalPresentationStyle = .overFullScreen
                    self.videoCapture.stop()
                    VoiceAssistant.instance.stop()
                }
            }
            if identifier == "showMatchView" {
                if let viewController = segue.destination as? MatchViewController {
                    viewController.delegate = self
                    viewController.object = self.currentObject
                    viewController.modalPresentationStyle = .overFullScreen
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
