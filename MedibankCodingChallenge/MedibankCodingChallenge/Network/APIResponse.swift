//
//  Responses.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 10/2/2026.
//

protocol APIResponse: Codable {
    associatedtype Value: Decodable
    
    var status: String { get }
    var totalResults: Int? { get }
}

struct ArticlesAPIResponse: APIResponse {
    typealias Value = Article
    
    var status: String
    var totalResults: Int?
    var articles: [Value]
}
