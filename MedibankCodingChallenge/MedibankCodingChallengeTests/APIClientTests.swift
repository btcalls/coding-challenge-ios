import Foundation
import XCTest
@testable import MedibankCodingChallenge

// MARK: - Helpers

private func makeSession() -> URLSession {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    
    return URLSession(configuration: config)
}

private func makeClient(baseURL: URL) -> APIClient {
    var headers: APIClient.Headers = [
        "content-type": "application/json; charset=utf-8",
        "Accept": "application/json"
    ]
    
    if let apiKey = Bundle.main.apiKey {
        headers["X-Api-Key"] = apiKey
    }
    
    return APIClient(
        baseURL: baseURL,
        session: makeSession(),
        decoder: JSONDecoder(),
        defaultHeaders: headers,
        enableLogging: true
    )
}

private func httpResponse(url: URL,
                          status: Int,
                          headers: [String: String] = [:]) -> HTTPURLResponse {
    return HTTPURLResponse(url: url,
                           statusCode: status,
                           httpVersion: nil,
                           headerFields: headers)!
}

// MARK: - XCTest Suite

final class APIClientTests: XCTestCase {
    private let path = "everything"
    private let queryItems: [URLQueryItem] = [
        .init(name: "q", value: "Swift"),
        .init(name: "language", value: "en"),
        .init(name: "pageSize", value: "20")
    ]
    
    func testBadRequest() async throws {
        guard let base = Bundle.main.apiURL else {
            fatalError("API values not provided.")
        }
        
        let client = makeClient(baseURL: base)
        let errorBody = try JSONSerialization.data(withJSONObject: MockValues.apiErrorBody)
        
        MockURLProtocol.responseProvider = { request in
            XCTAssertEqual(request.httpMethod, HTTPMethod.GET.rawValue)
            XCTAssertEqual(
                request.url?.absoluteString,
                base.appending(path: self.path).absoluteString
            )
            
            return (httpResponse(url: request.url!, status: 400), errorBody)
        }
        
        do {
            let endpoint = Endpoint<Data>(path: path)
            _ = try await client.send(endpoint)
            
            XCTFail("Expected error to be thrown")
        } catch let APIError.serverError(statusCode, data) {
            XCTAssertEqual(statusCode, 400)
            XCTAssertEqual(data, errorBody)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testBuildRequestHeadersAndQuery() async throws {
        guard let base = Bundle.main.apiURL,
              let apiKey = Bundle.main.apiKey else {
            fatalError("API values not provided.")
        }
        
        let client = makeClient(baseURL: base)
        let endpoint = Endpoint<Data>(path: path, queryItems: queryItems)
        let request = try await client.buildRequest(for: endpoint)
        
        XCTAssertEqual(request.httpMethod, HTTPMethod.GET.rawValue)
        
        let urlString = try XCTUnwrap(request.url?.absoluteString)
        
        XCTAssertTrue(urlString.contains("q=Swift"))
        XCTAssertTrue(urlString.contains("language=en"))
        XCTAssertTrue(urlString.contains("pageSize=20"))

        // Check header values
        XCTAssertEqual(request.value(forHTTPHeaderField: "X-Api-Key"), apiKey)
    }
    
    func testGETSuccessDecodes() async throws {
        guard let base = Bundle.main.apiURL else {
            fatalError("API values not provided.")
        }
        
        let client = makeClient(baseURL: base)
        let data = try JSONEncoder().encode(MockValues.articlesResponse)
        
        MockURLProtocol.responseProvider = { request in
            XCTAssertEqual(request.httpMethod, HTTPMethod.GET.rawValue)
            XCTAssertEqual(
                request.url?.absoluteString,
                base.appending(path: self.path)
                    .appending(queryItems: self.queryItems)
                    .absoluteString
            )
            
            return (httpResponse(url: request.url!, status: 200), data)
        }
        
        let endpoint: Endpoint = .getArticles(queryItems)
        let result = try await client.send(endpoint)
        let first = result.articles.first
        
        XCTAssertTrue(result.articles.count > 0)
        XCTAssertEqual(first, MockValues.article)
    }
}
