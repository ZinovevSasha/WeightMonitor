//
//  Formatters.swift
//  WeightMonitor
//
//  Created by Александр Зиновьев on 04.05.2023.
//

import Foundation

final class Formatters {    
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 1
        formatter.roundingMode = .halfUp
        return formatter
    }()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")       
        return formatter
    }()
}
