//
//  Endpoint.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import Foundation

/// A lightweight description of an API endpoint.
/// Provide the expected `Response` type at the call-site.
struct Endpoint<Response>: Sendable {
    var path: String
    var method: HTTPMethod
    var queryItems: [URLQueryItem]
    var headers: APIClient.Headers
    
    init(
        path: String = "",
        method: HTTPMethod = .GET,
        queryItems: [URLQueryItem] = [],
        headers: APIClient.Headers = [:]
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
    }
}

extension Endpoint {
    static func getArticles(
        _ queryItems: [URLQueryItem]
    ) -> Endpoint<ArticlesAPIResponse> {
        .init(path: "everything", queryItems: queryItems)
    }
}
