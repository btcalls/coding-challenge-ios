//
//  HeadlineView.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import Foundation
import Combine
import SwiftData

@MainActor
final class HeadlinesViewModel: AppViewModel {
    typealias Value = [Article]
    
    @Published var isLoading: Bool = true
    @Published var errorMessage: String?
    // Initial value as placeholder for loading state
    @Published var data: [Article] = MockValues.articles
    @Published var fetchInfo: String = ""
    
    private let client: APIClient
    private let dataStore: SourcesDataStore
    
    private var hasLoadedOnce = false
    
    var hasSources: Bool {
        return !dataStore.fetchSelected().isEmpty
    }
    
    init() {
        guard let base = Bundle.main.apiURL else {
            fatalError("Cannot initialise APIClient: Missing base URL configuration in .xcconfig")
        }
        
        self.client = APIClient(baseURL: base, enableLogging: true)
        self.dataStore = SourcesDataStore()
    }
    
    func fetchArticlesIfNeeded(withQuery query: String = "") async {
        guard !hasLoadedOnce else {
            return
        }
        
        hasLoadedOnce = true
        
        await fetchArticles(withQuery: query)
    }
    
    func fetchArticles(withQuery query: String = "") async {
        defer {
            isLoading = false
        }
        
        let sources = dataStore.fetchSelected()
        
        do {
            data = MockValues.articles
            isLoading = true
            fetchInfo = "Connecting..."
            
            // Configure query items
            var queryItems: [URLQueryItem] = [
                .init(name: "language", value: "en"),
                .init(name: "pageSize", value: "20")
            ]
            
            if !query.isEmpty {
                queryItems.append(.init(name: "q", value: query))
            }
            
            if !sources.isEmpty {
                let value = sources.map(\.id).joined(separator: ",")
                
                queryItems.append(.init(name: "sources", value: value))
            }
            
            // Fetch from API
            let result = try await client.send(.getArticles(queryItems))
            
            data = result.articles
            errorMessage = nil
            fetchInfo = "Updated last \(Date().formatted(date: .abbreviated, time: .shortened))"
        } catch {
            // Clear current articles since it may no longer coincide with user's sources selection
            data = []
            errorMessage = error.localizedDescription
            
            // Stored in fetchInfo directly since error messages are not handled by parent.
            if sources.isEmpty {
                fetchInfo = "No sources selected"
            } else {
                fetchInfo = "Failed fetching articles"
            }
        }
    }
    
    func save(article: Article) {
        article.isSaved = true
        
        SwiftDataManager.shared.container?.mainContext.insert(article)
        try? SwiftDataManager.shared.container?.mainContext.save()
    }
}
