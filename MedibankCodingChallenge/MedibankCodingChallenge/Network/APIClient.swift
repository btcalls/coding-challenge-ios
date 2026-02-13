//
//  APIClient.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 9/2/2026.
//

import Foundation
import os

/// Common HTTP methods supported by the networking layer.
enum HTTPMethod: String, Sendable {
    case GET
}

/// Errors that can be thrown by the networking layer.
enum APIError: Error, LocalizedError, Sendable {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int, message: String?)
    case decodingFailed(underlying: Error)
    case unknown(underlying: Error)

    /// A more human-readable error description.
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL could not be constructed."
        
        case .invalidResponse:
            return "The server returned an invalid response."
        
        case .serverError(let status, let message):
            return message ?? "Server responded with status code \(status)."
        
        case .decodingFailed(let underlying):
            return "Failed to decode response: \(underlying.localizedDescription)"
        
        case .unknown(let underlying):
            return underlying.localizedDescription
        }
    }
}

/// A simple, composable API client built on `URLSession` and Swift Concurrency.
final class APIClient: @unchecked Sendable {
    typealias Headers = [String: String]
    
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    private let enableLogging: Bool
    
    /// Create an API client.
    /// - Parameters:
    ///   - baseURL: The base URL for all endpoints (e.g., https://api.example.com).
    ///   - session: The `URLSession` to use. Defaults to `.shared`.
    ///   - decoder: JSON decoder for decoding responses.
    ///   - enableLogging: When true, prints basic request/response logs to the console.
    init(
        baseURL: URL,
        session: URLSession = .shared,
        decoder: JSONDecoder = .standard,
        defaultHeaders: Headers = [:],
        enableLogging: Bool = false
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
        self.enableLogging = enableLogging
    }
    
    // MARK: - Public API
    
    /// Sends a request for the given endpoint and decodes the response to `Response`.
    /// - Parameter endpoint: The endpoint description.
    /// - Returns: The decoded response value.
    @discardableResult
    func send<Response: Decodable>(_ endpoint: Endpoint<Response>) async throws -> Response {
        let request = try await buildRequest(for: endpoint)
        
        if enableLogging {
            Logger.log(request: request)
        }
        
        let (data, response) = try await session.data(for: request)
        
        // Check for invalid HTTP response
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if enableLogging {
            Logger.log(response: http, data: data)
        }
        
        // Check for invalid HTTP status codes
        guard (200...299).contains(http.statusCode) else {
            throw APIError.serverError(
                statusCode: http.statusCode,
                message: try errorMessage(for: http.statusCode, with: data)
            )
        }
        
        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw APIError.decodingFailed(underlying: error)
        }
    }
    
    /// Configures the `URLRequest` based on provided `Endpoint`.
    /// - Parameter endpoint: Basis for the request's details such as `path`, etc.
    /// - Returns: The `URLRequest` ready for use.
    func buildRequest<Response>(for endpoint: Endpoint<Response>) async throws -> URLRequest {
        // Append default headers to request
        var defaultHeaders: Headers = [
            "content-type": "application/json; charset=utf-8",
            "Accept": "application/json"
        ]
        
        if let apiKey = Bundle.main.apiKey {
            defaultHeaders["X-Api-Key"] = apiKey
        }
        
        // Ensure we do not double-encode a leading slash in `path`.
        let sanitizedPath = endpoint.path.hasPrefix("/") ? String(endpoint.path.dropFirst()) : endpoint.path
        var components = URLComponents(url: baseURL.appendingPathComponent(sanitizedPath),
                                       resolvingAgainstBaseURL: false)
        
        if !endpoint.queryItems.isEmpty {
            // Avoid empty query key-value pairs; keep duplicates as provided.
            components?.queryItems = endpoint.queryItems
        }
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }

        // Create URL request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        // Merge default headers with endpoint-specific headers (endpoint wins on conflicts)
        let headers = defaultHeaders.merging(endpoint.headers, uniquingKeysWith: { _, new in new })
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
    /// Generates a human-readable error message given the corresponding `statusCode`.
    /// - Parameters:
    ///   - statusCode: The HTTP response's status code.
    ///   - data: The `Data` instance from `URLRequest`.
    /// - Returns: The error message corresponding to the status code.
    func errorMessage(for statusCode: Int, with data: Data) throws -> String {
        let response = try decoder.decode(ErrorAPIResponse.self, from: data)
        
        // Handle common error status codes for API
        switch(statusCode) {
        case 400:
            return "Scope of search is too broad."
            
        case 429:
            return "Reached requests limit for Developer accounts."
            
        default:
            return response.message
        }
    }
}
