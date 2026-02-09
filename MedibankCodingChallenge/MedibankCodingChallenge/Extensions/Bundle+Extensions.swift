//
//  Bundle+Extensions.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 9/2/2026.
//

import Foundation

extension Bundle {
    /// Retrieves URL as specified in the .xcconfig file.
    var apiURL: String? {
        guard let url = fetch("CONFIG_API_URL") as String? else {
            return nil
        }
        
        return "https://\(url)"
    }
    /// Retrieves API key as specified in the .xcconfig file.
    var apiKey: String? {
        return fetch("CONFIG_API_KEY") as String?
    }
    
    /// Retrieves value from Bundle instance for given key.
    /// - Parameter key: The key to lookup value for.
    /// - Returns: Optional. Value of type `T`.
    private func fetch<T>(_ key: String) -> T? {
        return object(forInfoDictionaryKey: key) as? T
    }
}
