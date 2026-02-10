import Foundation
import XCTest
@testable import MedibankCodingChallenge

private final class MockURLProtocol: URLProtocol {
    static var responseProvider: ((URLRequest) throws -> (URLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.responseProvider else {
            fatalError("MockURLProtocol.responseProvider not set")
        }
        
        do {
            let (response, data) = try handler(request)
            
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if !data.isEmpty {
                client?.urlProtocol(self, didLoad: data)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
        /* no-op */
    }
}

// MARK: - Helpers

private func makeSession() -> URLSession {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    
    return URLSession(configuration: config)
}

private func makeClient(baseURL: URL) -> APIClient {
    var headers: APIClient.Headers = [:]
    
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
    private let queryItems: [URLQueryItem] = [
        .init(name: "q", value: "Swift"),
        .init(name: "language", value: "en"),
        .init(name: "pageSize", value: "20")
    ]
    
    func testBadRequest() async throws {
        guard let value = Bundle.main.apiURL,
              let base = URL(string: value) else {
            fatalError("API values not provided.")
        }
        
        let client = makeClient(baseURL: base)
        let errorBody = try JSONSerialization.data(withJSONObject: [
            "status": "error",
            "code": "parametersMissing",
            "message": "Required parameters are missing, the scope of your search is too broad. Please set any of the following required parameters and try again: q, qInTitle, sources, domains."
        ])
        
        MockURLProtocol.responseProvider = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(request.url?.absoluteString, base.absoluteString)
            
            return (httpResponse(url: request.url!, status: 400), errorBody)
        }
        
        do {
            let endpoint = Endpoint<ArticlesAPIResponse>()
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
        guard let value = Bundle.main.apiURL,
              let base = URL(string: value),
              let apiKey = Bundle.main.apiKey else {
            fatalError("API values not provided.")
        }
        
        let client = makeClient(baseURL: base)
        let endpoint = Endpoint<Data>(queryItems: queryItems)
        let request = try await client.buildRequest(for: endpoint)
        
        XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
        
        let urlString = try XCTUnwrap(request.url?.absoluteString)
        
        XCTAssertTrue(urlString.contains("q=Swift"))
        XCTAssertTrue(urlString.contains("language=en"))
        XCTAssertTrue(urlString.contains("pageSize=20"))

        // Check header values
        XCTAssertEqual(request.value(forHTTPHeaderField: "X-Api-Key"), apiKey)
    }
    
    func testGETSuccessDecodes() async throws {
        guard let value = Bundle.main.apiURL,
              let base = URL(string: value) else {
            fatalError("API values not provided.")
        }
        
        let client = makeClient(baseURL: base)
        let article = Article(
            source: .init(name: "MacRumors"),
            author: "Joe Rossignol",
            title: "Swift Student Challenge Submissions Now Open Ahead of WWDC 2026",
            articleDescription: "Apple today announced that submissions for the 2026 Swift Student Challenge are now open through Saturday, February 28.\n\n\n\n\n\nThe annual Swift Student Challenge gives eligible student developers around the world the opportunity to showcase their coding capabil…",
            url: URL(string: "https://www.macrumors.com/2026/02/06/2026-swift-student-challenge-begins/")!,
            thumbnail: URL(string: "https://images.macrumors.com/t/6K4a_PAoQ2OPtugA2uAOj6kUwS8=/1600x/article-new/2025/11/2026-Swift-Student-Challenge.jpg")!,
            publishedAt: try! Date("2026-02-06T16:48:13Z", strategy: .iso8601)
        )
        let data = try JSONEncoder().encode(article)
        
        MockURLProtocol.responseProvider = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(request.url?.absoluteString,
                           base.appending(queryItems: self.queryItems).absoluteString)
            
            return (httpResponse(url: request.url!, status: 200), data)
        }
        
        let endpoint = Endpoint<Article>(queryItems: queryItems)
        let result = try await client.send(endpoint)
        let first = result//result.articles.first
        
        XCTAssertEqual(first, article)
    }
}
