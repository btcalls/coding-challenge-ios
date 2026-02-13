//
//  MockValues.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import Foundation

/// Namespace for mock values used globally.
enum MockValues {
    
    // MARK: - Models
    
    static let articleSource = ArticleSource(name: "Gizmodo.com")
    static let article = Article(
        source: Self.articleSource,
        author: "James Pero",
        title: "The Best Gadgets of January 2026",
        articleDescription: "If new gadgets are your thing, then there's arguably not a more fruitful month than January.",
        url: URL(string: "https://gizmodo.com/best-gadgets-january-2026-2000714453")!,
        thumbnail: URL(string: "https://gizmodo.com/app/uploads/2026/01/Best-gadgets-of-January-2026-1200x675.jpeg")!,
        publishedAt: try! Date("2026-01-30T12:30:48Z", strategy: .iso8601)
    )
    static let articles: [Article] = [
        .init(
            source: ArticleSource(name: "SourceOne.com"),
            title: .placeholder(length: 38),
            articleDescription: .placeholder(length: 56),
            url: URL(string: "http://www.sourceone.com")!,
            publishedAt: Date()
        ),
        .init(
            source: ArticleSource(name: "SourceTwo.com"),
            title: .placeholder(length: 42),
            articleDescription: .placeholder(length: 56),
            url: URL(string: "http://www.sourcetwo.com")!,
            publishedAt: Date()
        ),
        .init(
            source: ArticleSource(name: "SourceThree.com"),
            title: .placeholder(length: 49),
            articleDescription: .placeholder(length: 56),
            url: URL(string: "http://www.sourcethree.com")!,
            publishedAt: Date()
        )
    ]
    static let source = Source(
        id: "australian-financial-review",
        name: "Australian Financial Review",
        url: URL(string: "http://www.afr.com")!,
        category: "business"
    )
    static let sources: [Source] = [
        .init(
            id: "1",
            name: .placeholder(length: 10),
            url: URL(string: "http://www.sampleone.com")!,
            category: "general"
        ),
        .init(
            id: "2",
            name: .placeholder(length: 10),
            url: URL(string: "http://www.sampletwo.com")!,
            category: "general"
        ),
        .init(
            id: "3",
            name: .placeholder(length: 10),
            url: URL(string: "http://www.samplethree.com")!,
            category: "general"
        ),
        .init(
            id: "4",
            name: .placeholder(length: 10),
            url: URL(string: "http://www.samplefour.com")!,
            category: "general"
        ),
        .init(
            id: "5",
            name: .placeholder(length: 10),
            url: URL(string: "http://www.samplefive.com")!,
            category: "general"
        )
    ]
    
    // MARK: - API
    
    static let apiErrorBody: [String: String] = [
        "status": "error",
        "code": "parametersMissing",
        "message": "Required parameters are missing, the scope of your search is too broad. Please set any of the following required parameters and try again: q, qInTitle, sources, domains."
    ]
    static let articlesResponse = ArticlesAPIResponse(
        status: "ok",
        totalResults: 1,
        articles: articles
    )
    static let sourcesResponse = SourcesAPIResponse(
        status: "ok",
        totalResults: 1,
        sources: sources
    )
    
    /// Simulate calling of `.getArticles` endpoint.
    /// - Parameters:
    ///   - query: The query to filter mock data.
    ///   - seconds: The delay of execution.
    /// - Returns: The mocked response.
    static func fetchArticles(
        with query: String,
        delay seconds: Double = 1
    ) async throws -> ArticlesAPIResponse {
        var response = articlesResponse
        
        if !query.isEmpty {
            response.articles = response.articles
                .filter { $0.title.contains(query) }
        }
        
        try await Task.sleep(for: .seconds(seconds))
        
        return response
    }
    
    /// Simulate calling of `.getSources` endpoint.
    /// - Parameter seconds: The delay of execution.
    /// - Returns: The mocked response.
    static func fetchSources(delay seconds: Double = 1) async throws -> SourcesAPIResponse {
        try await Task.sleep(for: .seconds(seconds))
        
        return sourcesResponse
    }
}
