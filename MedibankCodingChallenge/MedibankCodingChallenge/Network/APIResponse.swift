//
//  APIResponse.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 10/2/2026.
//

protocol APIResponse: Codable {
    associatedtype Value: Decodable
    
    var status: String { get }
    var totalResults: Int? { get }
}

/// API response object for fetching `Article` instances.
struct ArticlesAPIResponse: APIResponse {
    typealias Value = Article
    
    var status: String
    var totalResults: Int?
    var articles: [Value]
}

/// API response object for fetching `Source` instances.
struct SourcesAPIResponse: APIResponse {
    typealias Value = Source
    
    var status: String
    var totalResults: Int?
    var sources: [Value]
}

/// API response object generated when request results in an error..
struct ErrorAPIResponse: Decodable {
    var status: String
    var code: String
    var message: String
}
