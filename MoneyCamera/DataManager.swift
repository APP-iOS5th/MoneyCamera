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
            print("Data saved successfully with \(results.count) results.") // 디버깅 메시지 추가
        } else {
            print("Failed to save data")
        }
        printSavedResults() // 저장된 결과를 출력하는 함수 호출
    }
    
    func loadResults() -> [CurrencyRecognitionResult] {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey) {
            print("Loaded raw data: \(data.count) bytes") // 디버깅 메시지 추가
            
            do {
                NSKeyedUnarchiver.setClass(CurrencyRecognitionResult.self, forClassName: "CurrencyRecognitionResult")
                if let decodedResults = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [CurrencyRecognitionResult] {
                    print("Data loaded successfully with \(decodedResults.count) results.") // 디버깅 메시지 추가
                    return decodedResults
                } else {
                    print("Failed to decode data") // 디버깅 메시지 추가
                }
            } catch {
                print("Error during unarchiving: \(error)")
            }
        } else {
            print("No data found in UserDefaults") // 디버깅 메시지 추가
        }
        return []
    }
    
    func removeResult(_ result: CurrencyRecognitionResult) {
        var results = loadResults()
        if let index = results.firstIndex(where: { $0.date == result.date && $0.totalAmount == result.totalAmount }) {
            results.remove(at: index)
            if let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: results, requiringSecureCoding: false) {
                UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
                print("Data removed successfully. Remaining results: \(results.count)") // 디버깅 메시지 추가
            } else {
                print("Failed to remove data")
            }
        }
    }
    
    private func printSavedResults() {
        let results = loadResults()
        print("Saved data count: \(results.count)") // 디버깅 메시지 추가
        for (index, result) in results.enumerated() {
            print("Result \(index + 1): \(result.totalAmount)원, Date: \(result.date), Image size: \(result.image.size)")
        }
    }
}
