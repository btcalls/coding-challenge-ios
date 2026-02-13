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
    @Published var data: [Article] = MockValues.articles // Provided initial value as placeholder for loading state
    
    private let manager: SwiftDataManager
    
    init() {
        self.manager = SwiftDataManager.shared
    }
    
    /// Fetch saved `Article` instances from the data store.
    func fetchSavedArticles() {
        defer {
            isLoading = false
        }
        
        isLoading = true
        
        // Configure filter, and sort descriptors
        let fetchDescriptor = FetchDescriptor<Article>(
            predicate: #Predicate { $0.isSaved },
            sortBy: [SortDescriptor(\.publishedAt, order: .reverse)]
        )
        let articles = try? manager.container?.mainContext.fetch(
            fetchDescriptor
        )
        
        data = articles ?? []
    }
    
    /// Deletes an `Article` instance from the data store.
    ///
    /// Initiates a reload of saved records to be reflected on the view.
    /// - Parameter article: The `Article` instance to be removed.
    func delete(article: Article) {
        self.manager.container?.mainContext.delete(article)
        try? self.manager.container?.mainContext.save()
        
        fetchSavedArticles()
    }
}
