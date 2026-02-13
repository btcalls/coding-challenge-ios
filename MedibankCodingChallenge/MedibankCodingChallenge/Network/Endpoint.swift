//
//  Endpoint.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import Foundation

/// A lightweight description of an API endpoint.
///
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
    /// `Endpoint` instance configured to fetch `ArticlesAPIResponse`.
    /// - Parameter queryItems: The query items to be appended to the request's URL.
    /// - Returns: Configured `Endpoint` instance.
    static func getArticles(
        _ queryItems: [URLQueryItem]
    ) -> Endpoint<ArticlesAPIResponse> {
        return .init(path: "everything", queryItems: queryItems)
    }
    
    /// `Endpoint` instance configured to fetch `SourcesAPIResponse`.
    /// - Parameter queryItems: The query items to be appended to the request's URL.
    /// - Returns: Configured `Endpoint` instance.
    static func getSources(
        _ queryItems: [URLQueryItem]
    ) -> Endpoint<SourcesAPIResponse>{
        return .init(path: "top-headlines/sources", queryItems: queryItems)
    }
}
