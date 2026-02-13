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
    
    private let dataStore: ArticlesDataStore
    
    init(container: ModelContainer?) {
        guard let container else {
            fatalError("Cannot initialise: ModelContainer not provided.")
        }
        
        self.dataStore = ArticlesDataStore(container: container)
    }
    
    /// Fetch saved `Article` instances from the data store.
    func fetchSavedArticles() {
        defer {
            isLoading = false
        }
        
        isLoading = true
        
        // Configure filter, and sort descriptors        
        data = dataStore.fetchSaved()
    }
    
    /// Deletes an `Article` instance from the data store.
    ///
    /// Initiates a reload of saved records to be reflected on the view.
    /// - Parameter article: The `Article` instance to be removed.
    func delete(article: Article) {
        try? dataStore.delete(article)
        fetchSavedArticles()
    }
}
