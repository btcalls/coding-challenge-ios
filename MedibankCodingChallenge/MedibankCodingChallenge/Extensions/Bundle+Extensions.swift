//
//  Bundle+Extensions.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 9/2/2026.
//

import Foundation

extension Bundle {
    /// Optional. Retrieves URL as specified in the .xcconfig file.
    var apiURL: URL? {
        guard let host = fetch("CONFIG_API_HOST") as String? else {
            return nil
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = "/v2"
        
        return components.url
    }
    /// Optional. Retrieves API key as specified in the .xcconfig file.
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
