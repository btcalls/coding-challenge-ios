//
//  Item.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 9/2/2026.
//

import Foundation
import SwiftData

@Model
final class Article: Decodable {
    #Unique<Article>([\.source, \.author, \.url])
    
    var source: Source
    var author: String
    var title: String
    var articleDescription: String
    var url: URL
    var thumbnail: URL
    var publishedAt: Date
    var isSaved: Bool
    
    init(
        source: Source,
        author: String,
        title: String,
        articleDescription: String,
        url: URL,
        thumbnail: URL,
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
        
        source = try container.decode(Source.self, forKey: .source)
        author = try container.decode(String.self, forKey: .author)
        title = try container.decode(String.self, forKey: .title)
        articleDescription = try container
            .decode(String.self, forKey: .articleDescription)
        url = try container.decode(URL.self, forKey: .url)
        thumbnail = try container.decode(URL.self, forKey: .thumbnail)
        publishedAt = try container.decode(Date.self, forKey: .publishedAt)
        isSaved = false
    }
}
