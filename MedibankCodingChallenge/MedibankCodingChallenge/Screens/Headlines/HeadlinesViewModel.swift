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
    // Provided initial value as placeholder for loading state
    @Published var data: [Article] = [MockValues.article]
    @Published var fetchInfo: String = ""
    
    private let client: APIClient
    private var hasLoadedOnce = false
    
    init() {
        guard let base = Bundle.main.apiURL else {
            fatalError("Cannot initialise APIClient: Missing base URL configuration in .xcconfig")
        }
        
        self.client = APIClient(baseURL: base, enableLogging: true)
    }
    
    @MainActor
    func fetchArticlesIfNeeded() async {
        guard !hasLoadedOnce else {
            return
        }
        
        hasLoadedOnce = true
        
        await fetchArticles()
    }
    
    func fetchArticles() async {
        defer {
            isLoading = false
            
            if let _ = errorMessage {
                fetchInfo = "Failed fetching articles."
            } else {
                fetchInfo = "Updated last \(Date().formatted(date: .abbreviated, time: .shortened))"
            }
        }
        
        do {
            isLoading = true
            fetchInfo = "Connecting..."
            
            // TODO: As property
            let queryItems: [URLQueryItem] = [
                .init(name: "q", value: "Swift"),
                .init(name: "language", value: "en"),
                .init(name: "pageSize", value: "20")
            ]
            
            let result = try await client.send(.getArticles(queryItems))
            
            data = result.articles
            errorMessage = nil
        } catch(let error as APIError) {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func save(article: Article) {
        article.isSaved = true
        
        SwiftDataManager.shared.container?.mainContext.insert(article)
        try? SwiftDataManager.shared.container?.mainContext.save()
    }
}
