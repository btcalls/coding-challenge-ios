//
//  SearchContext.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 13/2/2026.
//

import Foundation
import Combine

/// Observable object used to delay query string input.
///
/// Used for cases like appending search strings for API endpoint requets.
final class SearchContext: ObservableObject {
    @Published var query = ""
    @Published var debouncedQuery = ""
    
    init(delay seconds: Double = 0.75) {
        $query
            .debounce(for: .seconds(seconds), scheduler: RunLoop.main)
            .assign(to: &$debouncedQuery)
    }
}
