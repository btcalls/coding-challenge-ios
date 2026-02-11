//
//  MockValues.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import Foundation

struct MockValues {
    // MARK: - Models
    
    static let source = Source(name: "MacRumors")
    static let article = Article(
        source: Self.source,
        author: "Joe Rossignol",
        title: "Swift Student Challenge Submissions Now Open Ahead of WWDC 2026",
        articleDescription: "Apple today announced that submissions for the 2026 Swift Student Challenge are now open through Saturday, February 28.\n\n\n\n\n\nThe annual Swift Student Challenge gives eligible student developers around the world the opportunity to showcase their coding capabil…",
        url: URL(string: "https://www.macrumors.com/2026/02/06/2026-swift-student-challenge-begins/")!,
        thumbnail: URL(string: "https://images.macrumors.com/t/6K4a_PAoQ2OPtugA2uAOj6kUwS8=/1600x/article-new/2025/11/2026-Swift-Student-Challenge.jpg")!,
        publishedAt: try! Date("2026-02-06T16:48:13Z", strategy: .iso8601)
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
