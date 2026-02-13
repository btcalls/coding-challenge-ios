//
//  SwiftDataManager.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 9/2/2026.
//

import SwiftData

final class SwiftDataManager {
    static let shared = SwiftDataManager()
    
    var container: ModelContainer?
    
    private init() {
        do {
            let schema = Schema([
                ArticleSource.self,
                Article.self,
                Source.self,
            ])
            let modelConfiguration = ModelConfiguration(schema: schema,
                                                        isStoredInMemoryOnly: false)
            
            container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Error initializing database container: \(error)")
        }
    }
}
