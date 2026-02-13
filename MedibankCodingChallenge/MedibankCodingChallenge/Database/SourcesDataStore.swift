//
//  SourcesDataStore.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 13/2/2026.
//

import SwiftData
import Foundation

final class SourcesDataStore {
    private let container: ModelContainer
    
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
        let sources = try? container.mainContext.fetch(
            fetchDescriptor
        )
        
        return sources ?? []
    }
    
    func fetchSelected() -> [Source] {
        let fetchDescriptor = FetchDescriptor<Source>(
            predicate: #Predicate { $0.isSelected },
            sortBy: [SortDescriptor(\.name, order: .forward)]
        )
        let sources = try? container.mainContext.fetch(
            fetchDescriptor
        )
        
        return sources ?? []
    }
    
    func save(_ source: Source) throws {
        try save([source])
    }
    
    func save(_ sources: [Source]) throws {
        try container.mainContext.transaction {
            for obj in sources {
                container.mainContext.insert(obj)
                try container.mainContext.save()
            }
        }
    }
}
