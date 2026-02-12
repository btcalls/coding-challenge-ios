//
//  HeadlineView.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import Foundation
import Combine

@MainActor
final class HeadlinesViewModel: AppViewModel {
    typealias Value = [Article]
    
    @Published var isLoading: Bool = true
    @Published var errorMessage: String?
    // Provided initial value as placeholder for loading state
    @Published var data: [Article] = [MockValues.article]
    
    private let client: APIClient
    
    init() {
        guard let base = Bundle.main.apiURL else {
            fatalError("Cannot initialise APIClient: Missing base URL configuration in .xcconfig")
        }
        
        self.client = APIClient(baseURL: base, enableLogging: true)
    }
    
    func fetchArticles() async {
        defer {
            isLoading = false
        }
        
        do {
            isLoading = true
            
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
}
