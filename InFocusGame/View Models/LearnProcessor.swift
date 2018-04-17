//
//  LearnProcessor.swift
//  InFocusGame
//
//  Created by Kirill Babich on 17/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import Foundation
import Vision

class LearnProcessor {
    let objectRecognition: ObjectRecognition?
    let semaphore: DispatchSemaphore?
    let voiveAssistant = VoiceAssistant()
    
    init(semaphore: DispatchSemaphore) {
        self.semaphore = semaphore
        objectRecognition = ObjectRecognition()
        objectRecognition?.setUpVision(completionHandler: requestDidComplete)
    }
    
    func analyze(results: [(String, Double)]) {
        
    }
    
    func requestDidComplete(request: VNRequest, error: Error?) {
        if let observations = request.results as? [VNClassificationObservation] {
            
            // The observations appear to be sorted by confidence already, so we
            // take the top 5 and map them to an array of (String, Double) tuples.
            let top5 = observations.prefix(through: 4)
                .map { ($0.identifier, Double($0.confidence)) }
            
            var hasNotebook = false
            for (i, pred) in top5.enumerated() {
                if pred.0.range(of:"notebook") != nil {
                    hasNotebook = true
                }
                print(String(format: "%d: %@ (%3.2f%%)", i + 1, pred.0, pred.1 * 100))
            }
            
            if (hasNotebook) {
                voiveAssistant.playFile(type: Voice.noticed)
            }
            
//            analyze(results: top5)
            DispatchQueue.main.async {
                self.semaphore?.signal()
            }
        }
    }
    
    func process(pixelBuffer: CVPixelBuffer) {
        objectRecognition?.predict(pixelBuffer: pixelBuffer)
    }
}
