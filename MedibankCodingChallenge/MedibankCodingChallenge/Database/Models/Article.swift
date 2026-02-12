//
//  Item.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 9/2/2026.
//

import Foundation
import SwiftData

@Model
final class Article: Codable {
    #Unique<Article>([\.source, \.title, \.url, \.publishedAt])
    
    var source: ArticleSource
    var author: String?
    var title: String
    var articleDescription: String
    var url: URL
    var thumbnail: URL?
    var publishedAt: Date
    var isSaved: Bool
    
    init(
        source: ArticleSource,
        author: String? = nil,
        title: String,
        articleDescription: String,
        url: URL,
        thumbnail: URL?,
        publishedAt: Date,
        isSaved: Bool = false
    ) {
        self.source = source
        self.author = author
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.thumbnail = thumbnail
        self.publishedAt = publishedAt
        self.isSaved = isSaved
    }
    
    private enum CodingKeys: String, CodingKey {
        case source, author, title, url, publishedAt
        case articleDescription = "description"
        case thumbnail = "urlToImage"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        source = try container.decode(ArticleSource.self, forKey: .source)
        author = try container.decodeIfPresent(String.self, forKey: .author)
        title = try container.decode(String.self, forKey: .title)
        articleDescription = try container.decode(String.self, forKey: .articleDescription)
        url = try container.decode(URL.self, forKey: .url)
        thumbnail = try container.decodeIfPresent(URL.self, forKey: .thumbnail)
        publishedAt = try container.decode(Date.self, forKey: .publishedAt)
        isSaved = false
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(source, forKey: .source)
        try container.encode(author, forKey: .author)
        try container.encode(title, forKey: .title)
        try container.encode(articleDescription, forKey: .articleDescription)
        try container.encode(url, forKey: .url)
        try container.encode(thumbnail, forKey: .thumbnail)
        try container.encode(publishedAt, forKey: .publishedAt)
    }
}

extension Article: Equatable {
    static func == (lhs: Article, rhs: Article) -> Bool {
        return (lhs.source.name == rhs.source.name &&
                lhs.author == rhs.author &&
                lhs.title == rhs.title)
    }
}
