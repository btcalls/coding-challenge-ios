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
    @Published var data: [Source] = MockValues.sources // Initial value as placeholder for loading state
    
    private let client: APIClient
    private let dataStore: SourcesDataStore
    
    init() {
        guard let base = Bundle.main.apiURL else {
            fatalError("Cannot initialise APIClient: Missing base URL configuration in .xcconfig")
        }
        
        self.client = APIClient(baseURL: base, enableLogging: true)
        self.dataStore = SourcesDataStore()
    }
    
    func fetchSources() async {
        defer {
            isLoading = false
        }
        
        // Check first if local storage is already populated
        let sources = dataStore.fetchAll()
        
        guard sources.isEmpty else {
            data = sources
            
            return
        }
        
        // Fetch from API if no Source records in storage
        do {
            isLoading = true
            
            let queryItems: [URLQueryItem] = [
                .init(name: "language", value: "en")
            ]
            let result = try await client.send(.getSources(queryItems))
            
            data = result.sources
            errorMessage = nil
            
            // Persist sources
            try dataStore.saveRecords(data)
        } catch(let error as APIError) {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func clearSelectedSources() {
        data = data.map {
            $0.isSelected = false
            
            return $0
        }
    }
    
    func saveSelectedSources() throws {
        try dataStore.saveRecords(data)
    }
}
