//
//  SavedArticlesView.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 12/2/2026.
//

import SwiftUI

struct SavedArticlesView: View {
    private var info: AttributedString {
        let word = TabKey.headlines.rawValue
        let string = "Head to the \(word) tab to search for articles."
        
        return string.highlight(word)
    }
    
    var body: some View {
        List {
        }
        .emptyView(
            if: true,
            label: Label("No Saved Articles", systemImage: "bookmark.fill"),
            description: {
                VStack {
                    Text("Saved articles will appear here.")
                    Text(info)
                }
            },
        )
    }
}

#Preview {
    SavedArticlesView()
}
