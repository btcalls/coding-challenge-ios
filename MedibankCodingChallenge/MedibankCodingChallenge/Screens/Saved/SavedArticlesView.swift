//
//  SavedArticlesView.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 12/2/2026.
//

import SwiftUI
import WebKit

/// Main view used for the `Saved` tab.
struct SavedArticlesView: View {
    @StateObject private var viewModel = SavedArticlesViewModel()
    
    private var emptyViewInfo: AttributedString {
        let word = TabKey.headlines.rawValue
        let string = "Head to the \(word) tab to browse for articles."
        
        return string.highlight(word)
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.data, id: \.url) { article in
                LazyVStack(spacing: Layout.Spacing.regular) {
                    NavigationLink(value: article) {
                        ArticleRow(article: article)
                            .asPlaceholder(reason: viewModel.isLoading)
                    }
                    .swipeActions(allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            viewModel.delete(article: article)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .padding(.top, Layout.Padding.comfortable)
            }
            .navigationDestination(for: Article.self) {
                WebView(url: $0.url)
                    .webViewBackForwardNavigationGestures(.disabled)
            }
            .navigationTitle("Your Articles")
            .emptyView(
                if: viewModel.errorMessage != nil || viewModel.data.isEmpty,
                label: Label("No Saved Articles", systemImage: "bookmark.fill"),
                description: {
                    VStack(alignment: .center, spacing: Layout.Spacing.regular) {
                        Text("Saved articles will appear here.")
                        Text(emptyViewInfo)
                    }
                },
            )
        }
        .task(id: "initial-load-saved-articles") {
            viewModel.fetchSavedArticles()
        }
    }
}

#Preview {
    SavedArticlesView()
}
