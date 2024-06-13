/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Contains the object recognition view controller for the Breakfast Finder.
*/

import UIKit
import AVFoundation
import Vision

class VisionObjectRecognition {
    var bufferSize: CGSize = .zero
    var rootLayer: CALayer! = nil
    var dict:[String:Int] = [:]
    
    static let shared = VisionObjectRecognition()
    
    private init() {
        let screenSize = UIScreen.main.bounds.size
        
        self.bufferSize.width = screenSize.width
        self.bufferSize.height = screenSize.height
    }
    
    private var detectionOverlay: CALayer! = nil
    
    // Vision parts
    private var requests = [VNRequest]()
    
    @discardableResult
    func setupVision() -> NSError? {
        // Setup Vision parts
        let error: NSError! = nil
        
        guard let modelURL = Bundle.main.url(forResource: "MixDataObjectDetector", withExtension: "mlmodelc") else {
            return NSError(domain: "VisionObjectRecognition", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
        }
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                if let results = request.results {
                    self.drawVisionRequestResults(results)
                }
            })
            self.requests = [objectRecognition]
            
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
        
        return error
    }
    
    func VisonHandler (image: CIImage) {
        let imageRequestHandler = VNImageRequestHandler(ciImage:image)
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    // 함수명 변경 또는 기능 추가 예정
    func drawVisionRequestResults(_ results: [Any]) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)

        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            // Select only the label with the highest confidence.
            let topLabelObservation = objectObservation.labels[0]
//            print(topLabelObservation.identifier)
//            print(topLabelObservation.confidence)
            addCount(key: topLabelObservation.identifier)
            _ = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
        }
        CATransaction.commit()
    }
    
    func addCount(key: String) {
        dict[key] = (dict[key] ?? 0) + 1
    }
    
    func dictReset() {
        dict.removeAll()
    }
}
