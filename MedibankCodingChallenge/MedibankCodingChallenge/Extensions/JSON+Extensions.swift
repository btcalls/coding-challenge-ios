//
//  JSON+Extensions.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import Foundation

extension JSONDecoder {
    /// The `JSONDecoder` instance with standard configuration such as encoding strategies.
    static var standard: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }
}
