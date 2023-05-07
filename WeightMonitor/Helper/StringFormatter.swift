//
//  StringFormatter.swift
//  WeightMonitor
//
//  Created by Александр Зиновьев on 04.05.2023.
//

import Foundation

final class StringFormatter {
    var weightFormatter: NumberFormatter
    var dateFormatter: DateFormatter
    
    init(formatters: Formatters) {
        self.weightFormatter = Formatters.numberFormatter
        self.dateFormatter = Formatters.dateFormatter
    }
    
    func convertWeightToString(_ weight: Double, for unit: UnitMass) -> String {
        let formattedWeight = formatWeight(weight)
        let russianTranslation = getUnitName(for: unit)
        return "\(formattedWeight) \(russianTranslation)"
    }
    
    func convertWeightChangeToString(change: Double, selectedUnitType: UnitMass) -> String {
        let changeString = formatWeight(change)
        let russianTranslation = getUnitName(for: selectedUnitType)
        return combineNumberWithSymbol(change, change: changeString, symbol: russianTranslation)
    }
    
    func formatDate(date: Date) -> String {        
        if isUserSelectedDayIsToday(date) {
            dateFormatter.dateFormat = "dd MMM"
        } else {
            dateFormatter.dateFormat = "dd.MM.yy"
        }
        return dateFormatter.string(from: date)
    }
    
    func getUnitName(for unit: UnitMass) -> String {
        let massUnitSymbols = ["kg": "кг", "lb": "фн"]
        return massUnitSymbols[unit.symbol] ?? unit.symbol
    }
    
    func getUnitSystemName(for unit: UnitMass) -> String {
        let massUnitSymbols = ["kg": "Метрическая система", "lb": "Английская система мер"]
        return massUnitSymbols[unit.symbol] ?? "Unknown unit system"
    }
    
    func format(text: String, for unit: UnitMass) -> String {
        var formattedText = ""
        let inputWithoutCommas = text.replacingOccurrences(of: ",", with: "")
        let inputNumber = Double(inputWithoutCommas) ?? 0.0
        
        if unit.symbol == UnitMass.kilograms.symbol {
            if inputNumber >= 100 {
                let wholeNumber = Int(inputNumber / 10)
                let decimalNumber = inputNumber.truncatingRemainder(dividingBy: 10)
                formattedText = "\(wholeNumber),\(Int(decimalNumber))"
            } else {
                formattedText = "\(Int(inputNumber))"
            }
        } else if unit.symbol == UnitMass.pounds.symbol {
            if inputNumber >= 1000 {
                let wholeNumber = Int(inputNumber / 10)
                let decimalNumber = inputNumber.truncatingRemainder(dividingBy: 10)
                formattedText = "\(wholeNumber),\(Int(decimalNumber))"
            } else if inputNumber >= 10 {
                formattedText = "\(Int(inputNumber))"
            } else {
                formattedText = "\(Int(inputNumber))"
            }
        } else {
            return formattedText
        }
        
        return formattedText
    }
    
    func formatStringToDouble(_ string: String) -> Double? {       
        if let number = weightFormatter.number(from: string) {
            return number.doubleValue
        } else {
            return nil
        }
    }
}
 
// MARK: - Private methods
private extension StringFormatter {
    private func formatWeight(_ weight: Double) -> String {
        return weightFormatter.string(from: NSNumber(value: weight)) ?? ""
    }
    
    func combineNumberWithSymbol(_ number: Double, change: String, symbol: String) -> String {
        // this needed to keep first record change showing nil        
        if number > 0 && number < .greatestFiniteMagnitude {
            return "+\(change) \(symbol)"
        } else if number < 0 {
            return "\(change) \(symbol)"
        } else if number == 0 {
            return "\(change) \(symbol)"
        } else {
            return ""
        }
    }
    
    private func isUserSelectedDayIsToday(_ date: Date) -> Bool {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let month = Calendar.current.component(.month, from: date)
        let currentYear = Calendar.current.component(.year, from: Date())
        let year = Calendar.current.component(.year, from: date)
        return currentMonth == month && currentYear == year
    }
}
