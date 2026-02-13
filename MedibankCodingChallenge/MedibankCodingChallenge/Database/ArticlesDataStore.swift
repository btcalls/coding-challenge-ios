//
//  ArticlesDataStore.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 13/2/2026.
//

import SwiftData
import Foundation

/// SwiftData data store for the `Article` model.
final class ArticlesDataStore: DataStore {
    typealias Value = Article
    
    var container: ModelContainer
    
    init(container modelContainer: ModelContainer?) {
        guard let modelContainer else {
            fatalError("Failed initialising SwiftDataManager")
        }
        
        self.container = modelContainer
    }
    
    func fetchAll() -> [Article] {
        let fetchDescriptor = FetchDescriptor<Article>(
            sortBy: [SortDescriptor(\.publishedAt, order: .reverse)]
        )
        let sources = try? container.mainContext.fetch(fetchDescriptor)
        
        return sources ?? []
    }
    
    func save(record: Article) throws {
        try saveRecords([record])
    }
    
    func saveRecords(_ records: [Article]) throws {
        try container.mainContext.transaction {
            for obj in records {
                container.mainContext.insert(obj)
            }
            
            try container.mainContext.save()
        }
    }
    
    func delete(_ record: Article) throws {
        container.mainContext.delete(record)
    }
    
    // MARK: - Helper methods
    
    func fetchSaved() -> [Article] {
        let fetchDescriptor = FetchDescriptor<Article>(
            predicate: #Predicate { $0.isSaved },
            sortBy: [SortDescriptor(\.publishedAt, order: .reverse)]
        )
        let articles = try? container.mainContext.fetch(fetchDescriptor)
        
        return articles ?? []
    }
}
