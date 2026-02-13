//
//  MockSwiftDataManager.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 9/2/2026.
//

import SwiftData

/// Mock class for `SwiftDataManager`
///
/// Used for testing and unit tests.
final class MockSwiftDataManager {
    var container: ModelContainer?
    var context: ModelContext?
    
    init() {
        do {
            let schema = Schema([
                ArticleSource.self,
                Article.self,
                Source.self
            ])
            let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            container = try ModelContainer(
                for: schema,
                configurations: configuration
            )
            
            if let container {
                context = ModelContext(container)
            }
        } catch {
            fatalError("Error initializing database container: \(error)")
        }
    }
}
