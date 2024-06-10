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
        if let jpegData = image.jpegData(compressionQuality: 1.0) {
            coder.encode(jpegData, forKey: "image")
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
        self.image = image
        self.totalAmount = totalAmount
        self.date = date
    }
}

