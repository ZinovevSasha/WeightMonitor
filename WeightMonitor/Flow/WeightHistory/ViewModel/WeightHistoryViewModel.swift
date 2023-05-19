import Foundation

// MARK: - DataProviderDelegate
extension WeightHistoryViewModel: DataProviderDelegate {
    func dataChanged() {
        updateWeightRecords()
        ifNewRecordAddedShowNotification()
    }
    
    func didUpdate(_ update: DataProviderUpdate) {
        self.batchUpdate = update
    }
    
    func ifNewRecordAddedShowNotification() {
        if let newRecordAdded = batchUpdate?.insertedIndexes, !newRecordAdded.isEmpty {
            isNewRecordAdded = true
        }
        batchUpdate = nil
    }
}

// Dont Know yet how to add property wrappers to protocol
// MARK: - WeightHistoryViewModelProtocol
protocol WeightHistoryViewModelProtocol {
    
    var isNewRecordAdded: Bool { get set }
    var weightRecords: [WeightHistoryCellViewModel] { get set }
    var initialRecord: WeightHistoryCellViewModel? { get set }
    
    func updateWeightRecords()
    func remove(at indexPath: IndexPath)
    func setWeightUnit()
    func setWeightUnit(_ unit: UnitMass)
}

final class WeightHistoryViewModel {
    // Public
    @Observable var isNewRecordAdded: Bool = false
    @Observable var weightRecords: [WeightHistoryCellViewModel] = []
    @Observable var initialRecord: WeightHistoryCellViewModel?
    var batchUpdate: DataProviderUpdate?
    
    // Private properties
    private var weightUnitService: WeightUnitServiceProtocol = WeightSystem.shared {
        didSet {
            updateWeightRecords()
        }
    }
    
    init(weightUnitService: WeightUnitServiceProtocol) {
        self.weightUnitService = weightUnitService
    }
    
    private lazy var dataProvider: DataProviderProtocol? = {
        do {
            return try DataProvider(delegate: self)
        } catch {
            print("Данные недоступны")
            return nil
        }
    }()
}

// MARK: - Public
extension WeightHistoryViewModel: WeightHistoryViewModelProtocol {
    func updateWeightRecords() {
        guard let weightRecords = dataProvider?.getAllWeightRecords() else {
            return
        }
            
        let updatedWeightRecords = convertWeightRecordsAndAddDifference(
            weightRecord: weightRecords,
            currentUnit: weightUnitService.currentUnit
        )
        self.weightRecords = updatedWeightRecords
    }

    func remove(at indexPath: IndexPath) {
        dataProvider?.deleteRecord(indexPath)
    }
    
    func setWeightUnit() {        
        weightUnitService.currentUnit = weightUnitService.getCurrentUnit()
    }
    
    func setWeightUnit(_ unit: UnitMass) {
        weightUnitService.currentUnit = unit
    }
    
    func updateViewWnenZeroRecords() {
        let weightRecord = WeightRecord(date: Date(), weight: 0, weightDifference: 0)
        initialRecord = WeightHistoryCellViewModel(weightRecord: weightRecord)
    }
    
    func getRecordIdForIndexPath(_ indexPath: IndexPath) -> String? {        
        return dataProvider?.getRecordAt(indexPath: indexPath).idString
    }
}

// MARK: - Private methods
private extension WeightHistoryViewModel {
    func convertWeightRecordsAndAddDifference(weightRecord: [WeightRecord], currentUnit: UnitMass) -> [WeightHistoryCellViewModel] {
        // Change to required unit
        let requiredUnitWeightRecord = weightRecord.map {
            self.convertUnitsOfWeight(to: currentUnit, $0)
        }
        // Add weight difference
        let updatedWeightRecords = addWeightDifference(to: requiredUnitWeightRecord)
        
        // Map to view model
        return updatedWeightRecords.map {
            WeightHistoryCellViewModel(weightRecord: $0)
        }
    }
    
    func convertUnitsOfWeight(to currentUnit: UnitMass, _ record: WeightRecord) -> WeightRecord {
                
        let newUnitWeight = Measurement(value: record.weight, unit: UnitMass.kilograms).converted(to: currentUnit).value
                       
        let newUnitWeightChange =  Measurement(value: record.weightDifference ?? 0, unit: UnitMass.kilograms).converted(to: currentUnit).value
                        
        return WeightRecord(id: record.identifier, date: record.date, weight: newUnitWeight, weightDifference: newUnitWeightChange)
    }
    
    // Function to calculate the weight difference between two weight records
    func calculateWeightDifference(record1: WeightRecord, record2: WeightRecord) -> Double {
        return record1.weight - record2.weight
    }

    // Function to update the weight difference of a weight record
    func updateWeightDifference(record: WeightRecord, nextRecord: WeightRecord?) -> WeightRecord {
        if let nextRecord = nextRecord {
            let weightDifference = calculateWeightDifference(record1: record, record2: nextRecord)
            return WeightRecord(id: record.identifier, date: record.date, weight: record.weight, weightDifference: weightDifference)
        } else {
            return WeightRecord(id: record.identifier, date: record.date, weight: record.weight, weightDifference: nil)
        }
    }

    // Function to update the weight differences of an array of weight records
    func updateWeightDifferences(records: [WeightRecord]) -> [WeightRecord] {
        return records.enumerated().map { (index, record) in
            // • index is the index of the current element in the records array.
            // • records.count is the total number of elements in the records array.
            // • records.count - 1 is the index of the last element in the records array.
            // • index < records.count - 1 is a condition that checks if the current element is not the last element in the array.
            // • If the condition is true, then records[index+1] is returned. This is the next element in the array after the current element.
            // • If the condition is false, then nil is returned. This means that there is no next element in the array after the current element.
            let nextRecord = index < records.count - 1 ? records[index+1] : nil
            
            return updateWeightDifference(record: record, nextRecord: nextRecord)
        }
    }

    // Function to set the weight difference of the last record to nil
    func setLastRecordWeightDifferenceToNil(records: [WeightRecord]) -> [WeightRecord] {
        var updatedRecords = records
        if let lastRecord = updatedRecords.last {
            updatedRecords[updatedRecords.count - 1] = WeightRecord(id: lastRecord.identifier, date: lastRecord.date, weight: lastRecord.weight, weightDifference: nil)
        }
        return updatedRecords
    }
    
    // Function to update an array of weight records
    func addWeightDifference(to weightRecords: [WeightRecord]) -> [WeightRecord] {
        var updatedRecords = updateWeightDifferences(records: weightRecords)
        updatedRecords = setLastRecordWeightDifferenceToNil(records: updatedRecords)
        return updatedRecords
    }
}

