//
//  Item.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 9/2/2026.
//

import Foundation
import SwiftData

@Model
final class Article {
    #Unique<Article>([\.author, \.url])
    
    var author: String
    var title: String
    var articleDescription: String
    var url: URL
    var thumbnail: URL
    var publishedAt: Date
    var isSaved: Bool
    
    init(
        author: String,
        title: String,
        articleDescription: String,
        url: URL,
        thumbnail: URL,
        publishedAt: Date
    ) {
        self.title = title
        self.articleDescription = articleDescription
        self.author = author
        self.url = url
        self.thumbnail = thumbnail
        self.publishedAt = publishedAt
        self.isSaved = false
    }
    
    private enum CodingKeys: String, CodingKey {
        case title, author, url, publishedAt
        case articleDescription = "description"
        case thumbnail = "urlToImage"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        author = try container.decode(String.self, forKey: .author)
        title = try container.decode(String.self, forKey: .title)
        articleDescription = try container
            .decode(String.self, forKey: .articleDescription)
        url = try container.decode(URL.self, forKey: .url)
        thumbnail = try container.decode(URL.self, forKey: .thumbnail)
        publishedAt = try container.decode(Date.self, forKey: .publishedAt)
        isSaved = false
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(author, forKey: .author)
        try container.encode(title, forKey: .title)
        try container.encode(articleDescription, forKey: .articleDescription)
        try container.encode(url, forKey: .url)
        try container.encode(thumbnail, forKey: .thumbnail)
        try container.encode(publishedAt, forKey: .publishedAt)
    }
}
