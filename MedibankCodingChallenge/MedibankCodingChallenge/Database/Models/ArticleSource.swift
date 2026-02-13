//
//  ArticleSource.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 9/2/2026.
//

import Foundation
import SwiftData

@Model
final class ArticleSource: Codable {
    #Unique<ArticleSource>([\.name])
    
    var id: String?
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \Article.source)
    var articles: [Article]?
    
    init(id: String? = nil, name: String) {
        self.id = id
        self.name = name
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
}
