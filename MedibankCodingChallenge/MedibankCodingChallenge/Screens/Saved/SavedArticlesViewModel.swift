//
//  SavedArticlesViewModel.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 12/2/2026.
//

import Foundation
import Combine
import SwiftData

@MainActor
final class SavedArticlesViewModel: AppViewModel {
    typealias Value = [Article]
    
    @Published var isLoading: Bool = true
    @Published var errorMessage: String?
    // Provided initial value as placeholder for loading state
    @Published var data: [Article] = []
    
    private let manager: SwiftDataManager
    
    init() {
        self.manager = SwiftDataManager.shared
    }
    
    func fetchSavedArticles() {
        defer {
            isLoading = false
        }
        
        isLoading = true
        
        let fetchDescriptor = FetchDescriptor<Article>(
            predicate: #Predicate { $0.isSaved },
            sortBy: [SortDescriptor(\.publishedAt, order: .reverse)]
        )
        let articles = try? manager.container?.mainContext.fetch(
            fetchDescriptor
        )
        
        data = articles ?? []
    }
}
