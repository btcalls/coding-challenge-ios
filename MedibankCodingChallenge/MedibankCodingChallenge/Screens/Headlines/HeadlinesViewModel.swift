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
    @Published var data: [Article] = MockValues.articles // Initial value as placeholder for loading state
    @Published var fetchInfo: String = ""
    
    private let client: APIClient
    private let articlesDataStore: ArticlesDataStore
    private let sourcesDataStore: SourcesDataStore
    
    /// Sets the view model to be used for mock testing.
    private var asMock = false
    /// Flag set once any `fetch()` call has succeeded at least once.
    private var hasLoadedOnce = false
    
    /// Checks whether there are selected `Source` instances in the data store.
    var hasSources: Bool {
        return !sourcesDataStore.fetchSelected().isEmpty
    }
    
    init(container: ModelContainer?, asMock: Bool = false) {
        guard let base = Bundle.main.apiURL else {
            fatalError("Cannot initialise APIClient: Missing base URL configuration in .xcconfig")
        }
        
        guard let container else {
            fatalError("Cannot initialise: ModelContainer not provided.")
        }
        
        self.client = APIClient(baseURL: base, enableLogging: true)
        self.articlesDataStore = ArticlesDataStore(container: container)
        self.sourcesDataStore = SourcesDataStore(container: container)
        self.asMock = asMock
    }
    
    /// Initiates fetching of new `[Article]` only on initial load.
    /// - Parameter query: The query to provide to the API request.
    func fetchArticlesIfNeeded(withQuery query: String = "") async {
        guard !hasLoadedOnce else {
            return
        }
        
        hasLoadedOnce = true
        
        await fetchArticles(withQuery: query)
    }
    
    /// Initiates fetching of `[Article]`.
    /// - Parameter query: The query to provide to the API request.
    func fetchArticles(withQuery query: String = "") async {
        defer {
            isLoading = false
        }
        
        let sources = sourcesDataStore.fetchSelected()
        let maxNoOfArticles = 50
        let articlePerSource = 10
        // Page size to either 50 max. or 10 articles per source
        let noOfArticles = articlePerSource * sources.count
        
        do {
            // To mock data fetching
            data = MockValues.articles
            
            isLoading = true
            fetchInfo = "Connecting..."
            
            // Configure query items
            var queryItems: [URLQueryItem] = [
                .init(name: "language", value: "en"),
                .init(name: "pageSize", value: "\(min(noOfArticles, maxNoOfArticles))")
            ]
            
            if !query.isEmpty {
                queryItems.append(.init(name: "q", value: query))
            }
            
            if !sources.isEmpty {
                let value = sources.map(\.id).joined(separator: ",")
                
                queryItems.append(.init(name: "sources", value: value))
            }
            
            // TODO: Better way of mocking API calls
            // Fetch from API or mock data
            var result: ArticlesAPIResponse
            
            if asMock {
                result = try await MockValues.fetchArticles(with: query)
            } else {
                result = try await client.send(.getArticles(queryItems))
            }
            
            data = result.articles
            errorMessage = nil
            fetchInfo = "Updated last \(Date().formatted(date: .abbreviated, time: .shortened))"
        } catch {
            // Clear current articles since it may no longer coincide with user's sources selection
            data = []
            
            if let e = error as? APIError {
                errorMessage = e.errorDescription
            } else {
                errorMessage = error.localizedDescription
            }
            
            // Display error message as info message (e.g. navigationSubtitle)
            fetchInfo = errorMessage ?? ""
        }
    }
    
    /// Saves an `Article` instance to the data store.
    /// - Parameter article: The `Article` instance to save.
    func save(article: Article) throws {
        article.isSaved = true
        
        try articlesDataStore.save(record: article)
    }
}
