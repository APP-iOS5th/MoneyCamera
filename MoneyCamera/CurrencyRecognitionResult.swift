//
//  CurrencyRecognitionResult.swift
//  MoneyCamera
//
//  Created by 장예진 on 6/10/24.
//


import UIKit

class CurrencyRecognitionResult: NSObject, NSCoding {
    var image: UIImage
    var totalAmount: String
    var date: Date
    
    init(image: UIImage, totalAmount: String, date: Date) {
        self.image = image
        self.totalAmount = totalAmount
        self.date = date
    }
    
    func encode(with coder: NSCoder) {
        if let jpegData = image.jpegData(compressionQuality: 0.8) { // JPEG 형식으로 저장
            coder.encode(jpegData, forKey: "image")
            print("Encoding Image Data: \(jpegData.count) bytes") // debug
        }
        coder.encode(totalAmount, forKey: "totalAmount")
        coder.encode(date, forKey: "date")
    }
    
    required init?(coder: NSCoder) {
        guard let imageData = coder.decodeObject(forKey: "image") as? Data,
              let image = UIImage(data: imageData),
              let totalAmount = coder.decodeObject(forKey: "totalAmount") as? String,
              let date = coder.decodeObject(forKey: "date") as? Date else {
            return nil
        }
        print("Decoding Image Data: \(imageData.count) bytes") // debug
        self.image = image
        self.totalAmount = totalAmount
        self.date = date
    }
}
