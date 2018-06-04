//
//  ReadViewController.swift
//  InFocusGame
//
//  Created by Kirill Babich on 25/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import UIKit
import CoreMedia

protocol TestModalViewControllerDelegate: ModalViewControllerDelegate  {
    var numberOfStars: Int { get set }
}

class ReadViewController: UIViewController, ScanProcessorDelegate, TestModalViewControllerDelegate {

    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var scanButton: UIButton!
    
    var category = Categories.fruitsAndVegetables
    
    var videoCapture: VideoCapture!
    var startTimes: [CFTimeInterval] = []
    var framesDone = 0
    var frameCapturingStartTime = CACurrentMediaTime()
    let semaphore = DispatchSemaphore(value: 2)
    
    var scannedObject = ""
    
    var scanProcessor: ScanProcessor?
    var numberOfStars: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpCamera()
        setUpInterface()
        initScanProcessor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.videoCapture.stop()
    }
    
    func setUpInterface() {
        scanButton.layer.cornerRadius = scanButton.frame.size.height / 2
        scanButton.clipsToBounds = true
        
        
        let blurredBackgroundView = UIVisualEffectView()
        blurredBackgroundView.frame = view.frame
        blurredBackgroundView.effect = UIBlurEffect(style: .light)
        
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
    
    func initScanProcessor() {
        scanProcessor = ScanProcessor(semaphore: semaphore, category: category)
        scanProcessor?.delegate = self
    }
    
    func continueProcess(from: String?) {
        if let f = from, f == "test" {
            self.overlayBlurredBackgroundView(style: .dark)
            self.performSegue(withIdentifier: "showMatchView", sender: self)
        }
        else {
            videoCapture.start()
        }
    }
    
    func objectScanned(object: String?) {
        DispatchQueue.main.async {
            if let obj = object {
                self.scannedObject = obj
                self.overlayBlurredBackgroundView(style: .dark)
                self.performSegue(withIdentifier: "showTest", sender: self)
            }
        }
    }
    
    func objectDetected(object: String?) {
        DispatchQueue.main.async {
            if let obj = object {
                self.scanButton.setImage(UIImage(named: "scan"), for: .normal)
            }
            else {
                self.scanButton.setImage(UIImage(named: "scan-gray"), for: .normal)
            }
        }
    }
    
    // Modal
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
    
    func removeBlurredBackgroundView() {
        for subview in view.subviews {
            if subview.isKind(of: UIVisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
    }
    
    func overlayBlurredBackgroundView(style: UIBlurEffectStyle) {
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        
        let blurredBackgroundView = UIVisualEffectView()
        
        blurredBackgroundView.frame = view.frame
        blurredBackgroundView.effect = UIBlurEffect(style: style)
        
        view.addSubview(blurredBackgroundView)
    }
    
    // End Modal
    
    @IBAction func scanButtonPressed(_ sender: UIButton) {
        scanProcessor?.scan()
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        VoiceAssistant.instance.playFile(type: Voice.click, overlap: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "showTest" {
                if let viewController = segue.destination as? TestViewController {
                    viewController.delegate = self
                    viewController.object = self.scannedObject
                    viewController.category = category
                    viewController.modalPresentationStyle = .overFullScreen
                    self.videoCapture.stop()
                    VoiceAssistant.instance.stop()
                }
            }
            if identifier == "showMatchView" {
                if let viewController = segue.destination as? MatchViewController {
                    viewController.delegate = self
                    viewController.object = self.scannedObject
                    viewController.stars = self.numberOfStars
                    viewController.modalPresentationStyle = .overFullScreen
                    self.videoCapture.stop()
                    VoiceAssistant.instance.stop()
                }
            }
        }
    }
    
}

extension ReadViewController: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        if let pixelBuffer = pixelBuffer {            
            semaphore.wait()
            DispatchQueue.global().async {
                self.scanProcessor?.process(pixelBuffer: pixelBuffer)
            }
        }
    }
}
