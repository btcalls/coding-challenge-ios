//
//  MockSwiftDataManager.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 9/2/2026.
//

import SwiftData

final class MockSwiftDataManager {
    var container: ModelContainer?
    var context: ModelContext?
    
    init() {
        do {
            let schema = Schema([
                Source.self,
                Article.self,
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
