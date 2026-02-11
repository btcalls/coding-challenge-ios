//
//  HeadlinesView.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import SwiftUI
import WebKit

struct HeadlinesView: View {
    @StateObject private var viewModel = HeadlinesViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.data, id: \.url) { article in
                LazyVStack(spacing: Layout.Spacing.regular) {
                    NavigationLink(value: article) {
                        ArticleRow(article: article)
                            .redacted(reason: viewModel.isLoading ? .placeholder : [])
                    }
                }
            }
            .navigationDestination(for: Article.self) {
                WebView(url: $0.url)
                    .webViewBackForwardNavigationGestures(.disabled)
            }
            .emptyView(
                if: viewModel.errorMessage != nil && viewModel.data.count == 0,
                label: Label("No Articles", systemImage: "newspaper"),
                description: {
                    Text("Articles from selected sources will appear here.")
                },
                actions: {
                    Button(action: {
                        Task {
                            await viewModel.fetchArticles()
                        }
                    }, label: {
                        Text("Get Articles")
                            .fontWeight(.medium)
                            .padding(.all, Layout.Padding.compact)
                    })
                    .buttonStyle(.glassProminent)
                }
            )
            .navigationTitle("Your News")
            .task {
                await viewModel.fetchArticles()
            }
            .refreshable {
                await viewModel.fetchArticles()
            }
        }
    }
}

#Preview {
    HeadlinesView()
}
