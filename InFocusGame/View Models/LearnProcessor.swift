//
//  LearnProcessor.swift
//  InFocusGame
//
//  Created by Kirill Babich on 17/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import Foundation
import Vision

protocol LearnProcessorDelegate: class {
    func objectChecked(correct: Bool, incorrectObject: String?)
}

class LearnProcessor {
    let objectRecognition: ObjectRecognition?
    let semaphore: DispatchSemaphore?    
    private var isChecking = false
    private var checkCounter = 0
    private var checkCounterValue = 0
    private var currentObjectIndex = 0
    private var currentObject = "apple"
    weak var delegate: LearnProcessorDelegate?
    private var randomObjectSequence: [Int] = []
    private var objectIsNoticed = false
    private var lastCheckedObjectsDict: [String: Int] = [:]
    let objects = Constants.flatObjects
    
    init(semaphore: DispatchSemaphore) {
        self.semaphore = semaphore
        objectRecognition = ObjectRecognition()
        objectRecognition?.setUpVision(completionHandler: requestDidComplete)
        
        randomObjectSequence = (0...objects.count-1).shuffled()
    }
    
    func check() {
        isChecking = true
    }
    
    func pickUpObjectForSearch() -> String? {
        if (currentObjectIndex > objects.count - 1) {
            currentObjectIndex = 0
            randomObjectSequence = (0...objects.count-1).shuffled()
            return nil
        }
        
        let object = objects[randomObjectSequence[currentObjectIndex]]
        currentObjectIndex += 1
        currentObject = object
        
        return object
    }
    
    func resultContainsObject(values: [(String, Double)], bound: Int?) -> Bool {
        for (i, pred) in values.enumerated() {
            if (bound != nil && i >= bound!) {
                return false
            }
            
            let id = pred.0.components(separatedBy: " ")[0]
            if ((Constants.objectsIds[currentObject]?.contains(id))! && pred.1 > 0.15) {
                print("\(i) - \(pred.0) - \(pred.1)")
                return true
            }
        }
        return false
    }
    
    
    
    func noticed(values: [(String, Double)]) {
        if (resultContainsObject(values: values, bound: nil)) {
            if (objectIsNoticed) {
                return
            }
            objectIsNoticed = true
            VoiceAssistant.instance.playFile(type: Voice.noticed, overlap: false)
            
        }
        else {
            objectIsNoticed = false
        }
    }
    
    // TODO - optimize selection mechanism
    func processCheck(values: [(String, Double)]) {
        if (checkCounter >= 10) {
            isChecking = false
            if (checkCounterValue > 5) {
                delegate?.objectChecked(correct: true, incorrectObject: nil)
            }
            else {
                // TODO - move it
                let last = lastCheckedObjectsDict.max { a, b in a.value < b.value }
                if let lastObjectIndex = Constants.objectsIds.index(where: { $1.contains((last?.key.components(separatedBy: " ")[0])!) }), Constants.objectsIds[lastObjectIndex] != nil {
                    delegate?.objectChecked(correct: false, incorrectObject: Constants.objectsIds[lastObjectIndex].key)
                }
                else {                    
                    delegate?.objectChecked(correct: false, incorrectObject: nil)
                }
            }
            print(3)
            lastCheckedObjectsDict = [:]
            checkCounterValue = 0
            checkCounter = 0
        }
        else {
            checkCounter += 1
            
            let first = (values.first?.0)!
            
            lastCheckedObjectsDict[first] = lastCheckedObjectsDict[first] == nil ? 1 : lastCheckedObjectsDict[first]! + 1
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
