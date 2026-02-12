//
//  String+Extensions.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 12/2/2026.
//

import SwiftUI

// MARK: - Helper modifiers

extension String {
    func highlight(_ words: [String],
                   font: Font = .default.bold(),
                   color: Color = Color.primary) -> AttributedString {
        var attrString = AttributedString(self)
        
        for word in words {
            if let range = attrString.range(of: word) {
                attrString[range].inlinePresentationIntent = .stronglyEmphasized
                attrString[range].foregroundColor = color
            }
        }
        
        return attrString
    }
    
    func highlight(_ word: String,
                   font: Font = .default.bold(),
                   color: Color = Color.primary) -> AttributedString {
        return highlight([word], font: font, color: color)
    }
}
