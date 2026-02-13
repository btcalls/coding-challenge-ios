//
//  Layout.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import SwiftUI

enum Typography {
    static let boldHeadline: Font = .system(.headline, weight: .bold)
    static let mediumSubheadline: Font = .system(.subheadline, weight: .medium)
    static let lightBody: Font = .system(.body, weight: .light)
}

extension View {
    func articleTitleStyle() -> some View {
        return self.font(Typography.boldHeadline)
            .foregroundStyle(Color.primary)
        
    }
    
    func secondaryTextStyle() -> some View {
        return self.font(Typography.mediumSubheadline)
            .foregroundStyle(Color.secondary)
        
    }
    
    func descriptionStyle() -> some View {
        return self.font(Typography.lightBody)
    }
    
    func sourceStyle() -> some View {
        return self.font(Typography.mediumSubheadline)
    }
}
