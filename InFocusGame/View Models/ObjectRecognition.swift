//
//  ObjectRecognition.swift
//  InFocusGame
//
//  Created by Kirill Babich on 17/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import Foundation
import Vision

class ObjectRecognition {
    private let model = MobileNet()
    private var request: VNCoreMLRequest!
    
    func setUpVision(completionHandler: @escaping (VNRequest, Error?) -> Void) {
        guard let visionModel = try? VNCoreMLModel(for: model.model) else {
            print("Error: could not create Vision model")
            return
        }
        
        request = VNCoreMLRequest(model: visionModel, completionHandler: completionHandler)
        request.imageCropAndScaleOption = .centerCrop
    }
    
    
    func show(results: [Prediction]) {
        var s: [String] = []
        for (i, pred) in results.enumerated() {
            s.append(String(format: "%d: %@ (%3.2f%%)", i + 1, pred.0, pred.1 * 100))
        }
    }
    
    typealias Prediction = (String, Double)
    
    func predict(pixelBuffer: CVPixelBuffer ) {
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }
}
