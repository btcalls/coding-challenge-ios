//
//  Layout.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import SwiftUI

enum Typography {
    static let articleTitle: Font = .system(.headline, weight: .bold)
    static let secondaryText: Font = .system(.subheadline, weight: .medium)
    static let description: Font = .system(.body, weight: .light)
}

extension View {
    func articleTitleStyle() -> some View {
        return self.font(Typography.articleTitle)
            .foregroundStyle(Color.primary)
        
    }
    
    func secondaryTextStyle() -> some View {
        return self.font(Typography.secondaryText)
            .foregroundStyle(Color.secondary)
        
    }
    
    func descriptionStyle() -> some View {
        return self.font(Typography.description)
    }
}
