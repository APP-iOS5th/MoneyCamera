//
//  DataManager.swift
//  MoneyCamera
//
//  Created by 장예진 on 6/10/24.
//

import UIKit

class DataManager {
    static let shared = DataManager()
    private let userDefaultsKey = "currencyRecognitionResults"
    
    private init() {}
    
    func saveResult(_ result: CurrencyRecognitionResult) {
        var results = loadResults()
        results.append(result)
        if let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: results, requiringSecureCoding: false) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        }
    }
    
    func loadResults() -> [CurrencyRecognitionResult] {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey) {
            do {
                NSKeyedUnarchiver.setClass(CurrencyRecognitionResult.self, forClassName: "CurrencyRecognitionResult")
                if let decodedResults = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [CurrencyRecognitionResult] {
                    return decodedResults
                }
            } catch {
                print("Error during unarchiving: \(error)")
            }
        }
        return []
    }
    
    func removeResult(_ result: CurrencyRecognitionResult) {
        var results = loadResults()
        if let index = results.firstIndex(where: { $0.date == result.date && $0.totalAmount == result.totalAmount }) {
            results.remove(at: index)
            if let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: results, requiringSecureCoding: false) {
                UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
            }
        }
    }
}

