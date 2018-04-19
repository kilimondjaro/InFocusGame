//
//  LearnProcessor.swift
//  InFocusGame
//
//  Created by Kirill Babich on 17/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import Foundation
import Vision

protocol LearnProcessotDelegate: class {
    func objectChecked(correct: Bool)
}

class LearnProcessor {
    let objectRecognition: ObjectRecognition?
    let semaphore: DispatchSemaphore?    
    private var isChecking = false
    private var checkCounter = 0
    private var checkCounterValue = 0
    private var currentObjectIndex = 0
    private var currentObject = "apple"
    weak var delegate: LearnProcessotDelegate?
    private var flatObjectsData: [String: Bool] = [:]
    private var filteredObjectsCount = 0
    private var randomObjectSequence: [Int] = []
    
    
    init(semaphore: DispatchSemaphore) {
        self.semaphore = semaphore
        objectRecognition = ObjectRecognition()
        objectRecognition?.setUpVision(completionHandler: requestDidComplete)
        
        
        
        let result = CoreDataManager.instance.fetch(entity: "FlatObjects")
        for data in result {
            for name in Constants.flatObjects {
                flatObjectsData[name] = data.value(forKey: name) as? Bool
            }
        }
        
        let filteredObjets = Constants.flatObjects.filter(({ flatObjectsData[$0]! }))
        filteredObjectsCount = filteredObjets.count
        
        randomObjectSequence = (0...filteredObjectsCount-1).shuffled()
    }
    
    func check() {
        isChecking = true
    }
    
    func pickUpObjectForSearch() -> String {
        
        let values = Constants.flatObjects.filter(({ flatObjectsData[$0]! }))
        let object = values[randomObjectSequence[currentObjectIndex]]
        currentObjectIndex += 1
        currentObject = object
        
        if (currentObjectIndex > filteredObjectsCount - 1) {
            currentObjectIndex = 0
            randomObjectSequence = (0...filteredObjectsCount-1).shuffled()
        }
        
        return object
    }
    
    
    func resultContainsObject(values: [(String, Double)], bound: Int?) -> Bool {
        for (i, pred) in values.enumerated() {
            if (bound != nil && i >= bound!) {
                return false
            }
            
            let id = pred.0.components(separatedBy: " ")[0]
            if (flatObjectsData[currentObject]! && (objectsDict[currentObject]?.contains(id))! && pred.1 > 0.15) {
                print("\(i) - \(pred.0) - \(pred.1)")
                return true
            }
        }
        return false
    }
    
    
    
    func noticed(values: [(String, Double)]) {
        if (resultContainsObject(values: values, bound: nil)) {
            VoiceAssistant.instance.playFile(type: Voice.noticed)
        }
    }
    
    // TODO - optimize selection mechanism
    func processCheck(values: [(String, Double)]) {
        if (checkCounter >= 10) {
            isChecking = false
            if (checkCounterValue > 5) {
                delegate?.objectChecked(correct: true)
            }
            else {
                // TODO - move it
                VoiceAssistant.instance.playFile(type: Voice.oops)
                delegate?.objectChecked(correct: false)
            }
            checkCounterValue = 0
            checkCounter = 0
        }
        else {
            checkCounter += 1
            
            checkCounterValue += resultContainsObject(values: values, bound: 3) ? 1 : 0
        }
    }
    
    func requestDidComplete(request: VNRequest, error: Error?) {
        if let observations = request.results as? [VNClassificationObservation] {
            
            // The observations appear to be sorted by confidence already, so we
            // take the top 5 and map them to an array of (String, Double) tuples.
            
            
            let top5 = observations.prefix(through: 4)
                .map { ($0.identifier, Double($0.confidence)) }
            
            if (isChecking) {
                processCheck(values: top5)
            }
            else {
                noticed(values: top5)
            }
            
            
            DispatchQueue.main.async {
                self.semaphore?.signal()
            }
        }
    }
    
    func process(pixelBuffer: CVPixelBuffer) {
        objectRecognition?.predict(pixelBuffer: pixelBuffer)
    }
}
