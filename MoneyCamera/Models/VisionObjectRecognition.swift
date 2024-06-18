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
    var processedImage: UIImage?
    
    
    static let shared = VisionObjectRecognition()
    
    private init() {
        let screenSize = UIScreen.main.bounds.size
        
        self.bufferSize.width = screenSize.width
        self.bufferSize.height = screenSize.height
    }
    
    private var detectionOverlay: CALayer! = nil
    
    // Vision parts
    var requests = [VNRequest]()
    
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
            objectRecognition.imageCropAndScaleOption = .scaleFill
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
        
        guard detectionOverlay != nil else {
            print("detectionOverlay is not initialized")
            return
        }
        
        detectionOverlay.sublayers?.removeAll()

            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)

            for observation in results where observation is VNRecognizedObjectObservation {
                guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                    continue
                }

                // Select only the label with the highest confidence.
                let topLabelObservation = objectObservation.labels[0]
                addCount(key: topLabelObservation.identifier)
                
                let boundingBox = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
                let boxLayer = createBoxLayer(rect: boundingBox, identifier: topLabelObservation.identifier)
                detectionOverlay.addSublayer(boxLayer)
            }
            CATransaction.commit()
    }
    
    private func createBoxLayer(rect: CGRect, identifier: String) -> CALayer {
        let boxLayer = CALayer()
        boxLayer.frame = rect
        boxLayer.borderWidth = 2.0
        boxLayer.borderColor = UIColor.red.cgColor
        boxLayer.cornerRadius = 4.0
        return boxLayer
    }
    
    func setupLayers() {
        rootLayer = CALayer()
        rootLayer.bounds = CGRect(x: 0, y: 0, width: bufferSize.width, height: bufferSize.height)
        rootLayer.position = CGPoint(x: bufferSize.width / 2, y: bufferSize.height / 2)
        rootLayer.backgroundColor = UIColor.clear.cgColor

        detectionOverlay = CALayer()
        detectionOverlay.bounds = rootLayer.bounds
        detectionOverlay.position = CGPoint(x: rootLayer.bounds.midX, y: rootLayer.bounds.midY)
        detectionOverlay.backgroundColor = UIColor.clear.cgColor
        rootLayer.addSublayer(detectionOverlay)
    }
    
    func addCount(key: String) {
        dict[key] = (dict[key] ?? 0) + 1
    }
    
    func dictReset() {
        dict.removeAll()
    }
}
