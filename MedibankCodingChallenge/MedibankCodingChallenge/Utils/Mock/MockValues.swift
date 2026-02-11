//
//  MockValues.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import Foundation

struct MockValues {
    // MARK: - Models
    
    static let source = Source(name: "Gizmodo.com")
    static let article = Article(
        source: Self.source,
        author: "James Pero",
        title: "The Best Gadgets of January 2026",
        articleDescription: "If new gadgets are your thing, then there's arguably not a more fruitful month than January.",
        url: URL(string: "https://gizmodo.com/best-gadgets-january-2026-2000714453")!,
        thumbnail: URL(string: "https://gizmodo.com/app/uploads/2026/01/Best-gadgets-of-January-2026-1200x675.jpeg")!,
        publishedAt: try! Date("2026-01-30T12:30:48Z", strategy: .iso8601)
    )
    
    // MARK: - API
    
    static let apiErrorBody: [String: String] = [
        "status": "error",
        "code": "parametersMissing",
        "message": "Required parameters are missing, the scope of your search is too broad. Please set any of the following required parameters and try again: q, qInTitle, sources, domains."
    ]
    static let articlesResponse = ArticlesAPIResponse(status: "ok",
                                                      totalResults: 1,
                                                      articles: [Self.article])
}
