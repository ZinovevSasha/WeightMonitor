//
//  WeightUnit.swift
//  WeightMonitor
//
//  Created by Александр Зиновьев on 02.05.2023.
//

import Foundation

protocol WeightUnitServiceProtocol {
    var currentUnit: UnitMass { get set }
    func getCurrentUnit() -> UnitMass
}

final class WeightSystem: WeightUnitServiceProtocol {
    static let shared = WeightSystem()
    
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    
    var currentUnit = UnitMass.kilograms {
        didSet {
            updateCurrentUnit(newUnit: currentUnit)
        }
    }
    
    func getCurrentUnit() -> UnitMass {
        if let symbol = userDefaults.string(forKey: Keys.WeightUnit.rawValue) {
            return UnitMass(symbol: symbol)
        } else {
            return UnitMass.kilograms
        }
    }
        
    // Private
    private enum Keys: String {
        case WeightUnit
    }
    
    private func updateCurrentUnit(newUnit: UnitMass) {
        userDefaults.set(newUnit.symbol, forKey: Keys.WeightUnit.rawValue)
    }
}
