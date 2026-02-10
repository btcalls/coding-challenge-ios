//
//  APIClient.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 9/2/2026.
//

import Foundation
import os

/// Common HTTP methods supported by the networking layer.
public enum HTTPMethod: String, Sendable {
    case get = "GET"
}

/// Errors that can be thrown by the networking layer.
public enum APIError: Error, LocalizedError, Sendable {
    case invalidURL
    case transportError(underlying: Error)
    case invalidResponse
    case serverError(statusCode: Int, data: Data)
    case decodingFailed(underlying: Error)
    case cancelled

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL could not be constructed."
        
        case .transportError(let underlying):
            return "Network transport failed: \(underlying.localizedDescription)"
        
        case .invalidResponse:
            return "The server returned an invalid response."
        
        case .serverError(let status, _):
            return "Server responded with status code \(status)."
        
        case .decodingFailed(let underlying):
            return "Failed to decode response: \(underlying.localizedDescription)"
        
        case .cancelled:
            return "The request was cancelled."
        }
    }
}

/// A lightweight description of an API endpoint.
/// Provide the expected `Response` type at the call-site.
public struct Endpoint<Response>: Sendable {
    public var path: String
    public var method: HTTPMethod
    public var queryItems: [URLQueryItem]
    public var headers: [String: String]

    public init(
        path: String,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:]
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
    }
}

/// A simple, composable API client built on URLSession and Swift Concurrency.
public final class APIClient: @unchecked Sendable {
    public typealias Headers = [String: String]
    
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    private let defaultHeaders: Headers
    private let enableLogging: Bool
    
    /// Create an API client.
    /// - Parameters:
    ///   - baseURL: The base URL for all endpoints (e.g., https://api.example.com).
    ///   - session: The URLSession to use. Defaults to `.shared`.
    ///   - encoder: JSON encoder for encoding request bodies.
    ///   - decoder: JSON decoder for decoding responses.
    ///   - defaultHeaders: Headers applied to every request unless overridden per-endpoint.
    ///   - interceptor: Optional hook to modify a request before sending (e.g., attach auth tokens).
    ///   - enableLogging: When true, prints basic request/response logs to the console.
    public init(
        baseURL: URL,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        defaultHeaders: Headers = [:],
        enableLogging: Bool = false
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
        self.defaultHeaders = defaultHeaders
        self.enableLogging = enableLogging
    }
    
    // MARK: - Public API
    
    /// Sends a request for the given endpoint and decodes the response to `Response`.
    /// - Parameter endpoint: The endpoint description.
    /// - Returns: The decoded response value.
    @discardableResult
    public func send<Response: Decodable>(_ endpoint: Endpoint<Response>) async throws -> Response {
        let request = try await buildRequest(for: endpoint)
        
        if enableLogging {
            Logger.log(request: request)
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let http = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            if enableLogging {
                Logger.log(response: http, data: data)
            }
            
            guard (200...299).contains(http.statusCode) else {
                throw APIError.serverError(statusCode: http.statusCode, data: data)
            }
            
            // Special-case decoding for Data
            if Response.self == Data.self, let cast = data as? Response {
                return cast
            }
            
            do {
                return try decoder.decode(Response.self, from: data)
            } catch {
                throw APIError.decodingFailed(underlying: error)
            }
        } catch {
            if let urlError = error as? URLError {
                if urlError.code == .cancelled {
                    throw APIError.cancelled
                }
                
                throw APIError.transportError(underlying: urlError)
            }
            
            if let apiError = error as? APIError {
                throw apiError
            }
            
            throw APIError.transportError(underlying: error)
        }
    }
    
    /// Sends a request and returns the raw `Data` response without attempting to decode.
    public func sendRaw(_ endpoint: Endpoint<Data>) async throws -> Data {
        try await send(endpoint)
    }
}

extension APIClient {
    private func buildRequest<Response>(for endpoint: Endpoint<Response>) async throws -> URLRequest {
        // Ensure we don't double-encode a leading slash in `path`.
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

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        // Merge default headers with endpoint-specific headers (endpoint wins on conflicts)
        let headers = defaultHeaders.merging(endpoint.headers, uniquingKeysWith: { _, new in new })

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
