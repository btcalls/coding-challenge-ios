//
//  HeadlineView.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import SwiftUI
import Combine

protocol AppViewModel: ObservableObject {
    associatedtype Value
    
    /// Flag to signify if any task or action is in progress. Add `@Published` to allow observation.
    var isLoading: Bool { get }
    /// Optional. Error message from failed task or action. Add `@Published` to allow observation.
    var errorMessage: String? { get }
    /// Data fetched from performed task or action. Add `@Published` to allow observation.
    var data: Value { get }
}

@MainActor
final class HeadlinesViewModel: AppViewModel {
    typealias Value = [Article]
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    // Provided initial value as placeholder
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
