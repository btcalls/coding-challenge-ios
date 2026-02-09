//
//  Source.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 9/2/2026.
//

import Foundation
import SwiftData

@Model
final class Source: Decodable {
    #Unique<Source>([\.name])
    
    var id: String?
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \Article.source)
    var articles: [Article]
    
    init(id: String? = nil, name: String, articles: [Article] = []) {
        self.id = id
        self.name = name
        self.articles = articles
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, articles
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        articles = []
    }
}
