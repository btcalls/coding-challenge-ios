//
//  SourcesViewModel.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 12/2/2026.
//

import Foundation
import Combine
import SwiftData

@MainActor
final class SourcesViewModel: AppViewModel {
    typealias Value = [Source]
    
    @Published var isLoading: Bool = true
    @Published var errorMessage: String?
    @Published var data: [Source] = []
    
    private let client: APIClient
    
    init() {
        guard let base = Bundle.main.apiURL else {
            fatalError("Cannot initialise APIClient: Missing base URL configuration in .xcconfig")
        }
        
        self.client = APIClient(baseURL: base, enableLogging: true)
    }
    
    func fetchSources() async {
        defer {
            isLoading = false
        }
        
        do {
            isLoading = true
            
            let queryItems: [URLQueryItem] = [
                .init(name: "language", value: "en")
            ]
            
            let result = try await client.send(.getSources(queryItems))
            
            data = result.sources
            errorMessage = nil
        } catch(let error as APIError) {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
