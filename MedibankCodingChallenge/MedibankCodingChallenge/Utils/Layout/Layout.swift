//
//  Layout.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import Foundation

/// Namespace for layout-related constant values.
enum Layout {
    /// Namespace for layout-related corner radius values.
    enum CornerRadius {
        static let regular: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
    }
    
    /// Namespace for layout-related padding values.
    enum Padding {
        static let compact: CGFloat = 6
        static let regular: CGFloat = 12
        static let comfortable: CGFloat = 18
    }
    
    /// Namespace for layout-related spacing values.
    enum Spacing {
        static let regular: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 20
    }
    
    /// Namespace for layout-related size  values.
    enum Size {
        static let thumbnail: CGFloat = 120
        static let thumbnailMax: CGFloat = 300
        static let sourceGrid: CGFloat = 60
    }
}
