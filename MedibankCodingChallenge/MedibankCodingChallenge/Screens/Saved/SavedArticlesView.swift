//
//  SavedArticlesView.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 12/2/2026.
//

import SwiftUI
import WebKit

struct SavedArticlesView: View {
    @StateObject private var viewModel = SavedArticlesViewModel()
    
    private var info: AttributedString {
        let word = TabKey.headlines.rawValue
        let string = "Head to the \(word) tab to search for articles."
        
        return string.highlight(word)
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.data, id: \.url) { article in
                LazyVStack(spacing: Layout.Spacing.regular) {
                    NavigationLink(value: article) {
                        ArticleRow(article: article)
                            .redacted(reason: viewModel.isLoading ? .placeholder : [])
                    }
                    .swipeActions(allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            viewModel.delete(article: article)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationDestination(for: Article.self) {
                WebView(url: $0.url)
                    .webViewBackForwardNavigationGestures(.disabled)
            }
            .emptyView(
                if: viewModel.errorMessage != nil || viewModel.data.isEmpty,
                label: Label("No Saved Articles", systemImage: "bookmark.fill"),
                description: {
                    VStack {
                        Text("Saved articles will appear here.")
                        Text(info)
                    }
                },
            )
            .navigationTitle("Your Articles")
        }
        .task(id: "initial-load-saved-articles") {
            viewModel.fetchSavedArticles()
        }
    }
}

#Preview {
    SavedArticlesView()
}
