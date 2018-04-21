//
//  ScanViewController.swift
//  InFocusGame
//
//  Created by Kirill Babich on 21/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import UIKit
import CoreMedia

class ScanViewController: UIViewController, ScanProcessorDelegate, ModalViewControllerDelegate {

    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var scannableLabel: UIView!
    
    var videoCapture: VideoCapture!
    var startTimes: [CFTimeInterval] = []
    var framesDone = 0
    var frameCapturingStartTime = CACurrentMediaTime()
    let semaphore = DispatchSemaphore(value: 2)
    
    var scannedObject = ""
    
    var scanProcessor: ScanProcessor?
    
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
        scannableLabel.layer.cornerRadius = scannableLabel.frame.size.height / 2
        scannableLabel.backgroundColor = UIColor.gray
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
        scanProcessor = ScanProcessor(semaphore: semaphore)
        scanProcessor?.delegate = self
    }
    
    func continueProcess() {
        videoCapture.start()
    }
    
    func objectScanned(object: String?) {
        DispatchQueue.main.async {
            if let obj = object {
                self.scannedObject = obj
                self.overlayBlurredBackgroundView(style: .dark)
                self.performSegue(withIdentifier: "showInfo", sender: self)
            }
        }
    }
    
    func objectDetected(object: String?) {
        DispatchQueue.main.async {
            if let obj = object {
                self.scannableLabel.backgroundColor = UIColor.green
            }
            else {
                self.scannableLabel.backgroundColor = UIColor.gray
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "showInfo" {
                if let viewController = segue.destination as? HelpViewController {
                    viewController.delegate = self
                    viewController.object = self.scannedObject
                    viewController.modalPresentationStyle = .overFullScreen
                    self.videoCapture.stop()
                    VoiceAssistant.instance.stop()
                }
            }
        }
    }
    
}

extension ScanViewController: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        if let pixelBuffer = pixelBuffer {
            // For better throughput, perform the prediction on a background queue
            // instead of on the VideoCapture queue. We use the semaphore to block
            // the capture queue and drop frames when Core ML can't keep up.
            semaphore.wait()
            DispatchQueue.global().async {
                self.scanProcessor?.process(pixelBuffer: pixelBuffer)
            }
        }
    }
}
