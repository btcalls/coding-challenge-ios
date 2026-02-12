//
//  Layout.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import Foundation

enum Layout {
    enum CornerRadius {
        static let regular: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
    }
    
    enum Padding {
        static let compact: CGFloat = 6
        static let regular: CGFloat = 12
        static let comfortable: CGFloat = 18
    }
    
    enum Spacing {
        static let regular: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 20
    }
    
    enum Size {
        static let thumbnail: CGFloat = 120
        static let thumbnailMax: CGFloat = 300
        static let sourceGrid: CGFloat = 60
    }
}
