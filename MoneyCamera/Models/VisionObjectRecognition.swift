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
//    var rootLayer: CALayer! = nil
    var dict:[String:Int] = [:]
    var selectedImage: UIImage?
    

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
                DispatchQueue.main.async(execute: { [self] in
                    // perform all the UI updates on the main queue
                    if let results = request.results {
                        self.drawVisionRequestResults(results)
                    }
                })
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
        guard let image = selectedImage else {
            print("Image not found")
            return
        }
        
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return
        }
        
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            
            // Select only the label with the highest confidence.
            let topLabelObservation = objectObservation.labels[0]
            addCount(key: topLabelObservation.identifier)
            
            let boundingBox = objectObservation.boundingBox
            let size = image.size
            let rect = CGRect(
                x: boundingBox.origin.x * size.width,
                y: (1 - boundingBox.origin.y - boundingBox.height) * size.height,
                width: boundingBox.width * size.width,
                height: boundingBox.height * size.height
            )
            
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(2.0)
            context.stroke(rect)
            
            let text = "\(topLabelObservation.identifier): \(String(format: "%.3f", topLabelObservation.confidence))"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 30),
                .foregroundColor: UIColor.red,
                .backgroundColor: UIColor.gray
            ]
            let textSize = (text as NSString).size(withAttributes: attributes)
            let textRect = CGRect(x: rect.origin.x, y: rect.origin.y - textSize.height, width: textSize.width, height: textSize.height)
            (text as NSString).draw(in: textRect, withAttributes: attributes)
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Update your imageView or any other UI element with the new image
        DispatchQueue.main.async {
            self.selectedImage = newImage
        }
    }
    
    func addCount(key: String) {
        dict[key] = (dict[key] ?? 0) + 1
    }
    
    func dictReset() {
        dict.removeAll()
    }
}
