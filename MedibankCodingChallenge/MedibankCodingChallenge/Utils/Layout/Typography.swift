//
//  Layout.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import SwiftUI

/// Namespace for typography-related values (e.g. fonts).
enum Typography {
    static let boldHeadline: Font = .system(.headline, weight: .bold)
    static let mediumSubheadline: Font = .system(.subheadline, weight: .medium)
    static let lightBody: Font = .system(.body, weight: .light)
}

extension View {
    /// Modifier to apply text styles suited for an article title.
    /// - Returns: Modified view.
    func articleTitleStyle() -> some View {
        return self.font(Typography.boldHeadline)
            .foregroundStyle(Color.primary)
        
    }
    
    /// Modifier to apply text styles suited for a secondary text
    /// - Returns: Modified view.
    func secondaryTextStyle() -> some View {
        return self.font(Typography.mediumSubheadline)
            .foregroundStyle(Color.secondary)
        
    }
    
    /// Modifier to apply text styles suited for an article description.
    /// - Returns: Modified view.
    func descriptionStyle() -> some View {
        return self.font(Typography.lightBody)
    }
    
    /// Modifier to apply text styles suited for an article source.
    /// - Returns: Modified view.
    func sourceStyle() -> some View {
        return self.font(Typography.mediumSubheadline)
    }
}
