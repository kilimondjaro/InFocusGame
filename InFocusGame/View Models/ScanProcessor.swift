//
//  ScanProcessor.swift
//  InFocusGame
//
//  Created by Kirill Babich on 21/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import Foundation
import Vision

protocol ScanProcessorDelegate: class {
    func objectScanned(object: String?)
    func objectDetected(object: String?)
}

class ScanProcessor {
    let objectRecognition = ObjectRecognition()
    let semaphore: DispatchSemaphore?
    
    let objects = Constants.flatObjects
    
    weak var delegate: ScanProcessorDelegate?
    
    private var scanCounter = 0
    private var isScanning = false
    
    private var lastScannedObjectsDict: [String: Int] = [:]
    
    init(semaphore: DispatchSemaphore) {
        self.semaphore = semaphore
        objectRecognition.setUpVision(completionHandler: requestDidComplete)
    }
    
    func scan() {
        isScanning = true
    }
    
    
    func processScan(values: [(String, Double)]) {
        if (scanCounter >= 10) {
            isScanning = false

            // TODO - move it
            let last = lastScannedObjectsDict.max { a, b in a.value < b.value }
            if let lastObjectIndex = Constants.objectsIds.index(where: { $1.contains((last?.key.components(separatedBy: " ")[0])!) }), Constants.objectsIds[lastObjectIndex] != nil {
                if (objects.contains(Constants.objectsIds[lastObjectIndex].key)) {
                    delegate?.objectScanned(object: Constants.objectsIds[lastObjectIndex].key)
                }
            }
            
            lastScannedObjectsDict = [:]
            scanCounter = 0
        }
        else {
            scanCounter += 1
            
            let first = (values.first?.0)!
            
            lastScannedObjectsDict[first] = lastScannedObjectsDict[first] == nil ? 1 : lastScannedObjectsDict[first]! + 1
        }
    }
    
    func processDetection(values: [(String, Double)]) {
        for object in values {
            let id = object.0.components(separatedBy: " ")[0]
            if let index = Constants.objectsIds.index(where: { $1.contains(id) }), Constants.objectsIds[index] != nil {
                if (objects.contains(Constants.objectsIds[index].key)) {
                    delegate?.objectDetected(object: Constants.objectsIds[index].key)
                }
                else {
                    delegate?.objectDetected(object: nil)
                }
                return
            }
        }
        delegate?.objectDetected(object: nil)
    }
    
    func requestDidComplete(request: VNRequest, error: Error?) {
        if let observations = request.results as? [VNClassificationObservation] {
            
            let top5 = observations.prefix(through: 4)
                .map { ($0.identifier, Double($0.confidence)) }
            
            if (isScanning) {
                processScan(values: top5)
            }
            else {
                processDetection(values: Array(top5.prefix(through: 1)))
            }
            
            
            DispatchQueue.main.async {
                self.semaphore?.signal()
            }
        }
    }
    
    func process(pixelBuffer: CVPixelBuffer) {
        objectRecognition.predict(pixelBuffer: pixelBuffer)
    }
}
