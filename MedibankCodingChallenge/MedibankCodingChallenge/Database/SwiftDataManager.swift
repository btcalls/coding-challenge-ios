//
//  SwiftDataManager.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 9/2/2026.
//

import SwiftData

class SwiftDataManager {
    static let shared = SwiftDataManager()
    
    var container: ModelContainer?
    var context: ModelContext?
    
    private init() {
        do {
            let schema = Schema([
                Item.self,
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            
            container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            
            if let container {
                context = ModelContext(container)
            }
        } catch {
            fatalError("Error initializing database container: \(error)")
        }
    }
}
