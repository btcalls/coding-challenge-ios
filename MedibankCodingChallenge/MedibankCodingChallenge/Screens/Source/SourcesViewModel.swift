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
    // Initial value as placeholder for loading state
    @Published var data: [Source] = MockValues.sources
    
    private let client: APIClient
    private let dataStore: SourcesDataStore
    
    /// Returns the number of currently selected `Source` instances from the data store.
    var selectedCount: Int {
        return data.count { $0.isSelected }
    }
    
    init(container: ModelContainer?) {
        guard let base = Bundle.main.apiURL else {
            fatalError("Cannot initialise APIClient: Missing base URL configuration in .xcconfig")
        }
        
        guard let container else {
            fatalError("Cannot initialise: ModelContainer not provided.")
        }
        
        self.client = APIClient(baseURL: base, enableLogging: true)
        self.dataStore = SourcesDataStore(container: container)
    }
    
    /// Fetch `[Source]` first from an API call.
    ///
    /// On subsequent calls, if properly saved, data is now fetched at the corresponding data store.
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
            // To mock data fetching
            data = MockValues.sources
            errorMessage = nil
            isLoading = true
            
            // Configure constant query items for endpoint
            let queryItems: [URLQueryItem] = [
                .init(name: "language", value: "en")
            ]
            let result = try await client.send(.getSources(queryItems))
            
            data = result.sources
            
            // Persist sources
            try dataStore.saveRecords(data)
        } catch(let error as APIError) {
            // Clear mock sources
            data = []
            errorMessage = error.errorDescription
        } catch {
            // Clear mock sources
            data = []
            errorMessage = error.localizedDescription
        }
    }
    
    /// Clear current selection.
    func clearSelectedSources() {
        data = data.map {
            $0.isSelected = false
            
            return $0
        }
    }
    
    /// Save all records, including changes to their `isSelected` values.
    func saveSelectedSources() throws {
        try dataStore.saveRecords(data)
    }
}
