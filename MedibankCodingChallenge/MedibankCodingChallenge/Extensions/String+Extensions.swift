//
//  String+Extensions.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 12/2/2026.
//

import SwiftUI

extension String {
    /// Highlight first occurence of provided strings by updating its font and/or changing its foreground color.
    /// - Parameters:
    ///   - words: The array of `String` instances to highlight.
    ///   - font: The font to apply to `words`.
    ///   - color: The color to apply to `words`.
    /// - Returns: `AttributedString` with newly highlighted strings.
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
    
    /// Highlight first occurence of provided strings by updating its font and/or changing its foreground color.
    /// - Parameters:
    ///   - word: The `String` instance to highlight.
    ///   - font: The font to apply to `word`.
    ///   - color: The color to apply to `word`.
    /// - Returns: `AttributedString` with the newly highlighted string.
    func highlight(_ word: String,
                   font: Font = .default.bold(),
                   color: Color = Color.primary) -> AttributedString {
        return highlight([word], font: font, color: color)
    }

    /// Generates a placeholder text. Typically used for skeleton views.
    /// - Parameter length: The length of the string.
    /// - Returns: `String` containing `length` number of characters.
    static func placeholder(length: Int) -> String {
        String(Array(repeating: "X", count: length))
    }
}
