//
//  DataManager.swift
//  MoneyCamera
//
//  Created by 장예진 on 6/10/24.
//


import Foundation
import UIKit

class DataManager {
    static let shared = DataManager()
    private let fileName = "currencyRecognitionResults.dat"
    
    private init() {}
    
    private var filePath: String {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(fileName).path
    }
    
    func saveResult(_ result: CurrencyRecognitionResult) {
        var results = loadResults()
        results.append(result)
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: results, requiringSecureCoding: true)
            try data.write(to: URL(fileURLWithPath: filePath))
        } catch {
            print("Error saving results: \(error)")
        }
    }
    
    func loadResults() -> [CurrencyRecognitionResult] {
        if FileManager.default.fileExists(atPath: filePath) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
                let decodedResults = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, CurrencyRecognitionResult.self], from: data) as? [CurrencyRecognitionResult]
                return decodedResults ?? []
            } catch {
                print("Error loading results: \(error)")
            }
        }
        return []
    }
    
    func removeResult(_ result: CurrencyRecognitionResult) {
        var results = loadResults()
        if let index = results.firstIndex(where: { $0.date == result.date && $0.totalAmount == result.totalAmount }) {
            results.remove(at: index)
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: results, requiringSecureCoding: true)
                try data.write(to: URL(fileURLWithPath: filePath))
            } catch {
                print("Error saving results: \(error)")
            }
        }
    }
}
