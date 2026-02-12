//
//  Source.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 12/2/2026.
//

import Foundation
import SwiftData

@Model
final class Source: Codable {
    #Unique<Source>([\.id, \.name])
    
    @Attribute(.unique)
    var id: String
    var name: String
    var url: URL
    var category: String
    var isSelected: Bool
    
    init (id: String, name: String, url: URL, category: String, isSelected: Bool = false) {
        self.id = id
        self.name = name
        self.url = url
        self.category = category
        self.isSelected = isSelected
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, url, category, isSelected
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(URL.self, forKey: .url)
        category = try container.decode(String.self, forKey: .category)
        isSelected = try container.decode(Bool.self, forKey: .isSelected)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(url, forKey: .url)
        try container.encode(category, forKey: .category)
        try container.encode(isSelected, forKey: .isSelected)
    }
}
