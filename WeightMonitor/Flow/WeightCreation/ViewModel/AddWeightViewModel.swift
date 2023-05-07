//
//  CreateWeightViewControllerViewModel.swift
//  WeightMonitor
//
//  Created by Александр Зиновьев on 05.05.2023.
//

import Foundation
import CoreData

final class AddWeightViewModel {
    @Observable var weightUnit: String = ""
    
    // Need to save data to core data
    private var weightRecordStore: WeightRecordStore?
    private var context: NSManagedObjectContext? {
        try? Context.getContext()
    }
    
    // MARK: - Init
    private var weightUnitService: WeightUnitServiceProtocol
    private let stringFormatter: StringFormatter
    private var userInput: UserInput
    private var recordIdForUpdate: String?
        
    init(
        weightUnitService: WeightUnitServiceProtocol = WeightSystem.shared,
        stringFormatter: StringFormatter = StringFormatter(formatters: Formatters()),
        userInput: UserInput = UserInput(),
        recordId: String? = nil
    ) {
        self.weightUnitService = weightUnitService
        self.stringFormatter = stringFormatter
        self.userInput = userInput
        self.recordIdForUpdate = recordId
                
        guard let context = context else { return }
        self.weightRecordStore = WeightRecordStore(context: context)
    }
}
    
extension AddWeightViewModel {
    var isAllFieldsEntered: Bool {
        userInput.isPossibleToAddWeight
    }
        
    func setWeight(_ weight: String?) {
        guard let weight = weight else { return }
        userInput.weight = stringFormatter.formatStringToDouble(weight)
    }
    
    func setDate(_ date: Date) {
        userInput.date = date
    }
    
    func addRecord() {
        guard let record = userInput.createRecord() else { return }
        
        let weightInKG = Measurement(value: record.weight, unit: weightUnitService.currentUnit)
            .converted(to: .kilograms).value
        
        let updatedRecord = WeightRecord(id: record.identifier, date: record.date, weight: weightInKG)
                    
        updateRecordOrAdd(updatedRecord: updatedRecord)
    }
    
    func formatString(_ text: String) -> String {
        stringFormatter.format(text: text, for: weightUnitService.currentUnit)
    }
    
    func updateView() {
        let currentWeightUnit = weightUnitService.currentUnit
        weightUnit = stringFormatter.getUnitName(for: currentWeightUnit)
    }
    
    func updateRecordOrAdd(updatedRecord: WeightRecord) {
        guard let recordIdForUpdate = recordIdForUpdate,
               let record = userInput.createRecord() else {
            try? weightRecordStore?.saveRecordCoreData(updatedRecord)
            return
        }
        
        weightRecordStore?.updateRecordWith(recordIdForUpdate, byFollowingRecod: record)
    }
}
