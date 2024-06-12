//
//  CurrencyRecognitionResult.swift
//  MoneyCamera
//
//  Created by 장예진 on 6/10/24.
//


import Foundation
import UIKit

class CurrencyRecognitionResult: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        return true
    }
    
    let totalAmount: String
    let date: Date
    let image: UIImage
    
    init(totalAmount: String, date: Date, image: UIImage) {
        self.totalAmount = totalAmount
        self.date = date
        self.image = image
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let totalAmount = aDecoder.decodeObject(of: NSString.self, forKey: "totalAmount") as String?,
              let date = aDecoder.decodeObject(of: NSDate.self, forKey: "date") as Date?,
              let imageData = aDecoder.decodeObject(of: NSData.self, forKey: "image") as Data?,
              let image = UIImage(data: imageData) else {
            return nil
        }
        
        self.init(totalAmount: totalAmount, date: date, image: image)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(totalAmount, forKey: "totalAmount")
        aCoder.encode(date as NSDate, forKey: "date")
        aCoder.encode(image.pngData() as NSData?, forKey: "image")
    }
}
