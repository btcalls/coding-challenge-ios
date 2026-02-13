//
//  SourcesDataStore.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 13/2/2026.
//

import SwiftData
import Foundation

/// SwiftData data store for the `Source` model.
final class SourcesDataStore: DataStore {
    typealias Value = Source
    
    var container: ModelContainer
    
    init() {
        guard let container = SwiftDataManager.shared.container else {
            fatalError("Failed initialising SwiftDataManager")
        }
        
        self.container = container
    }
    
    func fetchAll() -> [Source] {
        let fetchDescriptor = FetchDescriptor<Source>(
            sortBy: [SortDescriptor(\.name, order: .forward)]
        )
        let sources = try? container.mainContext.fetch(fetchDescriptor)
        
        return sources ?? []
    }
    
    func save(record: Source) throws {
        try saveRecords([record])
    }
    
    func saveRecords(_ records: [Source]) throws {
        try container.mainContext.transaction {
            for obj in records {
                container.mainContext.insert(obj)
            }
            
            try container.mainContext.save()
        }
    }
    
    func delete(_ record: Source) throws {
        container.mainContext.delete(record)
    }
    
    // MARK: - Helper methods
    
    func fetchSelected() -> [Source] {
        let fetchDescriptor = FetchDescriptor<Source>(
            predicate: #Predicate { $0.isSelected },
            sortBy: [SortDescriptor(\.name, order: .forward)]
        )
        let sources = try? container.mainContext.fetch(fetchDescriptor)
        
        return sources ?? []
    }
}
