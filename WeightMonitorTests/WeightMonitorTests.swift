//
//  WeightMonitorTests.swift
//  WeightMonitorTests
//
//  Created by Александр Зиновьев on 25.05.2023.
//

import XCTest
@testable import WeightMonitor

final class WeightMonitorTests: XCTestCase {
    func testAddWeightDifference() {
        let sut = WeightDifferentCalculator()
        
        let records = [
            WeightRecord(id: "1", date: Date(), weight: 150.0, weightDifference: nil),
            WeightRecord(id: "2", date: Date().addingTimeInterval(86400), weight: 148.5, weightDifference: nil),
            WeightRecord(id: "3", date: Date().addingTimeInterval(172800), weight: 147.0, weightDifference: nil)
        ]
        
        let expectedRecords = [
            WeightRecord(id: "1", date: Date(), weight: 150.0, weightDifference: +1.5),
            WeightRecord(id: "2", date: Date().addingTimeInterval(86400), weight: 148.5, weightDifference: +1.5),
            WeightRecord(id: "3", date: Date().addingTimeInterval(172800), weight: 147.0, weightDifference: nil)
        ]
    
        let updatedRecords = sut.addWeightDifference(to: records)
        XCTAssertEqual(updatedRecords, expectedRecords)
    }
    
    func testConvertingToKilograms() {
        let sut = WeightUnitConverter()
        let record = WeightRecord(date: Date(), weight: 200, weightDifference: 5.0)
        
        let convertedRecord = sut.convertUnitsOfWeight(to: UnitMass.kilograms, record)
        
        
        XCTAssertEqual(convertedRecord.weight, 200.0, accuracy: 0.001)
        if let weightDiff = convertedRecord.weightDifference {
            XCTAssertEqual(weightDiff, 5.0, accuracy: 0.001)
        }
    }
    
    func testConvertingToPounds() {
        let sut = WeightUnitConverter()
        let record = WeightRecord(date: Date(), weight: 90.72, weightDifference: -2.27)
        
        let convertedRecord = sut.convertUnitsOfWeight(to: UnitMass.pounds, record)
        
        // 200 lbs in kg and 5 lbs in 2.27 kg
        XCTAssertEqual(convertedRecord.weight, 200.0, accuracy: 0.01)
        if let weightDiff = convertedRecord.weightDifference {
            XCTAssertEqual(weightDiff, -5.0, accuracy: 0.01)
        }
    }
}
